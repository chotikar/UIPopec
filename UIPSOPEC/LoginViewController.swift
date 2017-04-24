

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import SystemConfiguration
import SWRevealViewController
import SkyFloatingLabelTextField

// width and height of current Scrren
let scWid = UIScreen.main.bounds.width
let scHei = UIScreen.main.bounds.height
let abacRed = UIColor(colorLiteralRed: 255/225, green: 0/225, blue: 0/225, alpha: 1)

class LoginViewController: UIViewController , FBSDKLoginButtonDelegate , UITextFieldDelegate , UITableViewDelegate , UITableViewDataSource {
    
    var activityiIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    let fm = FunctionMutual.self
    let ws = WebService.self
    @IBOutlet weak var MenuButton: UIBarButtonItem!
    var data:[String:AnyObject]!
    var userLoginInfor : UserLogInDetail!
    var text = ""
    var tokenn  = ""
    var bg : UIView!
    
    var phoneBg : UIImageView = {
        var pb = UIImageView()
        pb.frame = CGRect(x: 0, y: 0, width: scWid, height: scHei)
        pb.contentMode = .scaleToFill
        pb.image = UIImage(named: "loginBG2")
        return pb
    }()
    var loginView : UIView!
    var messageView : UIView!
    
    var logoAbac : UIImageView!
    
    var loginButton : UIButton!
    var username : SkyFloatingLabelTextField!
    var password : SkyFloatingLabelTextField!
    
    var signupView : UIView!
    
    var signupButton : UIButton!
    var email:SkyFloatingLabelTextField!
    var repassword : SkyFloatingLabelTextField!
    var backBut : UIButton!
    
    var facbookBut : FBSDKLoginButton!
    
    /////////////////////MessageList
    var logoutBut : UIBarButtonItem!
    var messageTableView : UITableView!
    var messageCell = "messageItemCell"
    var messageList = [MessageModel]()
    
    
    /// 1.signInPage 2.signUpPage
    var signinPageStatus : Bool!
    var toast : UIView!
    var url = UserLogInDetail()
    /////// From display 
    var fromMajorProgram = false
    var fromFacName : String!
    var fromDepName : String!
    var fromFacId : Int!
    var fromDepId : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Sidemenu()
        CustomNavbar()
        bg = UIView(frame: CGRect(x: 0, y: 0, width: scWid, height: scHei))
        bg.backgroundColor = UIColor.red
        self.view.addSubview(bg)
        mangegeLayout()
        print(CRUDProfileDevice.GetUserProfile().username)
        
    }
    
    // MARK : MUTAL
    func mangegeLayout(){
        self.userLoginInfor = CRUDProfileDevice.GetUserProfile()
        print(self.userLoginInfor.userId)
        if self.userLoginInfor.userId == 0 {
            self.goToMessage(status: false)
        }else{
            //self.getMessageListWs(uid: String(self.userLoginInfor.userId))
            self.goToMessage(status: true)
        }
    }
    
    func gotoChatPageByMessage(userId : Int64){
        let mm = MessageModel(uid: userId, fn: fromFacName, fid: fromFacId, pn: fromDepName, pid: fromDepId)
        let chatLogController = ChatLogTableViewController()
        chatLogController.facInfor = mm
        self.navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    
    func goToMessage(status : Bool){
        if status {
            if fromMajorProgram {
                gotoChatPageByMessage(userId: self.userLoginInfor.userId)
            }
            self.drawMessagePage()
            
        }else{
            self.drawLoginPage()
        }
    }
    
    func startIndicator(){
        self.activityiIndicator.center = self.view.center
        self.activityiIndicator.hidesWhenStopped = true
        self.activityiIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityiIndicator)
        activityiIndicator.startAnimating()
    }
    
    func stopIndicator(){
        self.activityiIndicator.stopAnimating()
    }
    
    // MARK: LogIn
    func signupPage(){
        self.drawSignupPage()
    }
    
    
    // MARK: Webservice
    func sentSignupWS(byfb: Int16, userDe: String, imageUrl: String){
        let udid = (UIDevice.current.identifierForVendor?.uuidString)! as String
        ws.sentSignUpWS(byfacebook: Int(byfb), userDetail: userDe, deviceId: udid, imageUrl:imageUrl ) { (responseData: UserLogInDetail, nil) in
            DispatchQueue.main.async( execute: {
                self.userLoginInfor = responseData
                if self.userLoginInfor.userId == 0 {
                    self.toastSignup(mess: self.userLoginInfor.result.message)
                }else{
                    print("Signup Success")
                    CRUDProfileDevice.SaveProfileDevice(loginInfor: self.userLoginInfor)
                    self.goToMessage(status: true)
                }
                self.stopIndicator()
            })
        }
    }
    
   func getMessageListWs(uid:String){
        ws.getRoomListWS(userid: uid) { (responseData: [MessageModel], nil) in
            DispatchQueue.main.async( execute: {
                self.messageList = responseData
                self.stopIndicator()
                self.messageTableView.reloadData()
            })
        }
    }
    
    func sentLoginWS(byfb: Int16, userDe: String){
        let udid = (UIDevice.current.identifierForVendor?.uuidString)! as String
        ws.sentSignInWS(byfacebook: Int(byfb), userDetail: userDe, deviceId: udid) { (responseData: UserLogInDetail, nil) in
            DispatchQueue.main.async( execute: {
                self.userLoginInfor = responseData
                if self.userLoginInfor.userId == 0 {
                    self.toastLogin(mess: self.userLoginInfor.result.message)
                }else{
                    CRUDProfileDevice.ClearProfileDevice()
                    CRUDProfileDevice.SaveProfileDevice(loginInfor: self.userLoginInfor)
                    let tr = CRUDProfileDevice.GetUserProfile()
                    print("GetValueWhen Login :\(tr.userId)")
                    self.goToMessage(status: true)
                }
                self.stopIndicator()
            })
        }
    }
    
    // MARK: Toast
    func toastSignup(mess:String){
        toast = fm.toast(message: mess)
        UIView.animate(withDuration: 1.8, delay: 0.0, options: [], animations: {
            self.toast.backgroundColor = UIColor.darkGray
        }, completion: { (finished: Bool) in
            UIView.animate(withDuration: 2.5, delay: 0, options: [], animations: {
                self.toast.backgroundColor = UIColor.clear
                self.toast.isHidden = true
            }, completion: nil)
            
        })
    }
    
    func toastLogin(mess:String){
        toast = fm.toast(message: mess)
        self.signupView.addSubview(self.toast)
        UIView.animate(withDuration: 1.8, delay: 0.0, options: [], animations: {
            self.toast.backgroundColor = UIColor.darkGray
        }, completion: { (finished: Bool) in
            UIView.animate(withDuration: 2.5, delay: 0, options: [], animations: {
                self.toast.backgroundColor = UIColor.clear
                self.toast.isHidden = true
            }, completion: nil)
            
        })
        
    }
    
    func toastNoInternet(){
        let toastLabel = UILabel(frame: CGRect(x: (scWid/2)-150, y: scHei*0.85, width: 300, height: 30))
        toastLabel.backgroundColor = UIColor.darkGray
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = NSTextAlignment.center;
        //self.view.addSubview(toastLabel)
        toastLabel.text = "No Internet Connection"
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        UIView.animate(withDuration: 4.0, delay: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        })
    }
    
    
    // MARK: Button action
    func signupAction() {
        //0 == incorect password
        //1 == correct password
        if password.text == repassword.text {
            if username.text != "" && email.text != "" {
                let ud = "\(username.text!);\(password.text!);\(email.text!)"
                print(ud)
                startIndicator()
                sentSignupWS(byfb: 0, userDe: ud, imageUrl: "N/A")
            }else {
                toastSignup(mess: "Invalid input")
            }
        }else{
            toastSignup(mess: "Invalid input")
        }
    }
    
    func signIn(sender : AnyObject){
        if password.text != "" {
            if username.text != "" {
                let ud = "N/A;\(password.text!);\(username.text!)"
                startIndicator()
                sentLoginWS(byfb: 0, userDe: ud)
                
            }else {
                toastSignup(mess: "Invalid input")
            }
        }else{
            toastSignup(mess: "Invalid input")
        }
        
    }
    
    
    func backAction(sender : AnyObject){
        drawLoginPage()
    }
    
    func logOutAction(sender : UIBarButtonItem){
        if self.userLoginInfor.byFacebook == 1{
            let manage = FBSDKLoginManager()
            manage.logOut()
            FBSDKAccessToken.setCurrent(nil)
            FBSDKProfile.setCurrent(nil)
        }
        CRUDProfileDevice.ClearProfileDevice()
        CRUDProfileDevice.SaveProfileDevice(loginInfor: UserLogInDetail())
        
        drawLoginPage()
        self.navigationItem.rightBarButtonItem = nil
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result:
        FBSDKLoginManagerLoginResult!, error : Error!) {
        
        if error != nil {
            print("Something Error")
            return
        }
        
        print("Login Successful")
        
        let accessToken = FBSDKAccessToken.current() // Print FBToken
        if(accessToken != nil)
        {
            tokenn = (accessToken?.tokenString)!
        }
        
        //--------This Part Print Picture, Email, Id, FirstName--------
        
        let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name"])
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil){
                print("Error: \(error as! String)")
            }else{
                self.data = result as! [String : AnyObject]
                print(self.data)
                //1304007822985652
                //http://graph.facebook.com/1304007822985652/picture?type=large&redirect=true&width=500&height=500
                
                if self.signinPageStatus {
                    self.sentLoginWS(byfb: 1, userDe: "\(self.data["first_name"] as! String);\(self.data["id"] as! String);\(self.tokenn)")
                }else{
                    self.sentSignupWS(byfb: 1, userDe: "\(self.data["first_name"] as! String);\(self.data["id"] as! String);\(self.tokenn)", imageUrl: ("http://graph.facebook.com/\(self.data["id"] as! String)/picture?type=large&redirect=true&width=300&height=300"))
                }
                
            }
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logout Successful")
    }
    
    // MARK: Draw 3 layout
    // MARK: Message
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: messageCell)
        let messageDe = messageList[indexPath.row]
        cell.textLabel?.text = messageDe.programName
        cell.detailTextLabel?.text = messageDe.facName
        cell.imageView?.image = UIImage(named: "User_Shield")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (scHei * 0.15)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let chatLogController = ChatLogViewController()
//        chatLogController.facInfor = messageList[indexPath.row]
//        navigationController?.pushViewController(chatLogController, animated: true)
//        tableView.deselectRow(at: indexPath, animated: true)
        
//        let chatLogController = ChatLogCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
//        chatLogController.facInfor = messageList[indexPath.row]
//        navigationController?.pushViewController(chatLogController, animated: true)
        
        let chatLogController = ChatLogTableViewController()
        chatLogController.facInfor = messageList[indexPath.row]
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func drawMessagePage(){
        self.signinPageStatus = false
        messageView = UIView(frame: CGRect(x: 0, y: 0, width: scWid, height: scHei))
        messageView.backgroundColor = UIColor.clear
        self.bg.addSubview(messageView)
        messageTableView = UITableView(frame: CGRect(x: 0, y: 0, width: scWid, height: scHei))
        self.messageView.addSubview(messageTableView)
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTableView.register(UserCell.self, forCellReuseIdentifier: messageCell)
        logoutBut = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logOutAction(sender:)))
        self.navigationItem.rightBarButtonItem = logoutBut
        self.messageList = []
        self.startIndicator()
        getMessageListWs(uid:String(self.userLoginInfor.userId))
    }
    
    func drawSignupPage(){
        self.signinPageStatus = false
        loginView = UIView(frame: CGRect(x: 0, y: 0, width: scWid, height: scHei))
        loginView.backgroundColor = UIColor.clear
        self.bg.addSubview(phoneBg)
        self.bg.addSubview(loginView)
        logoAbac = UIImageView(frame: CGRect(x: (scWid-(scHei*0.25))/2, y: scHei*0.15, width: scHei*0.25, height: scHei*0.25))
        logoAbac.image = UIImage(named: "abaclogo")
        var hei = logoAbac.frame.origin.y + logoAbac.frame.height + 20
        
        let boxHei = fm.calculateHeiFromString(text: "n/a", fontsize: fm.setFontSizeLight(fs: 27), tbWid: scWid*0.6)
        let boxFacebook = UIView(frame: CGRect(x: scWid*0.15, y: hei, width: scWid*0.7, height: boxHei.height))
        boxFacebook.layer.cornerRadius = 5
        boxFacebook.layer.borderColor = UIColor.white.cgColor
        boxFacebook.backgroundColor = UIColor.clear
        boxFacebook.alpha = 0.6
        facbookBut = FBSDKLoginButton(frame: CGRect(x: scWid*0.15, y: hei, width: scWid*0.7, height: boxHei.height))
        boxFacebook.addSubview(facbookBut)
        facbookBut.center = boxFacebook.center
        facbookBut.delegate = self
        facbookBut.readPermissions = ["public_profile","email"]
        hei = boxFacebook.frame.origin.y +  boxFacebook.frame.height + 5
        
        let boxOr = UILabel(frame: CGRect(x: scWid*0.15, y: hei, width: scWid*0.7, height: boxHei.height))
        boxOr.font = fm.setFontSizeLight(fs: 16)
        boxOr.textAlignment = .center
        boxOr.text = "or"
        hei = boxOr.frame.origin.y +  boxOr.frame.height + 5
        
        let boxUsername = UIView(frame: CGRect(x: scWid*0.15, y: hei, width: scWid*0.7, height: boxHei.height))
        boxUsername.layer.cornerRadius = 5
        boxUsername.backgroundColor = UIColor.white
        boxUsername.alpha = 0.7
        username = SkyFloatingLabelTextField(frame: CGRect(x: scWid*0.17, y: hei, width: scWid*0.66, height: boxHei.height))
        username.textColor = UIColor.black
        username.textAlignment = .center
        username.delegate = self
        username.font = fm.setFontSizeLight(fs: 14)
        username.keyboardType = .emailAddress
        hei = boxUsername.frame.origin.y +  boxUsername.frame.height + 10
        
        let boxEmail = UIView(frame: CGRect(x: scWid*0.15, y: hei, width: scWid*0.7, height: boxHei.height))
        boxEmail.layer.cornerRadius = 5
        boxEmail.backgroundColor = UIColor.white
        boxEmail.alpha = 0.7
        email = SkyFloatingLabelTextField(frame: CGRect(x: scWid*0.17, y: hei, width: scWid*0.66, height: boxHei.height))
        email.textColor = UIColor.black
        email.textAlignment = .center
        email.delegate = self
        email.font = fm.setFontSizeLight(fs: 14)
        email.keyboardType = .emailAddress
        hei = boxEmail.frame.origin.y +  boxEmail.frame.height + 10
        
        let boxPassword = UIView(frame: CGRect(x: scWid*0.15, y: hei, width: scWid*0.7, height: boxHei.height))
        boxPassword.layer.cornerRadius = 5
        boxPassword.backgroundColor = UIColor.white
        boxPassword.alpha = 0.7
        password = SkyFloatingLabelTextField(frame: CGRect(x: scWid*0.17, y: hei, width: scWid*0.66, height: boxHei.height))
        password.textColor = UIColor.black
        password.textAlignment = .center
        password.isSecureTextEntry = true
        password.delegate = self
        password.font = fm.setFontSizeLight(fs: 14)
        hei = password.frame.origin.y +  password.frame.height + 2
        
        let boxRepassword = UIView(frame: CGRect(x: scWid*0.15, y: hei, width: scWid*0.7, height: boxHei.height))
        boxRepassword.layer.cornerRadius = 5
        boxRepassword.backgroundColor = UIColor.white
        boxRepassword.alpha = 0.8
        repassword = SkyFloatingLabelTextField(frame: CGRect(x: scWid*0.17, y: hei, width: scWid*0.66, height: boxHei.height))
        repassword.textColor = UIColor.black
        repassword.isSecureTextEntry = true
        repassword.textAlignment = .center
        repassword.delegate = self
        repassword.font = fm.setFontSizeLight(fs: 14)
        hei = boxRepassword.frame.origin.y +  boxRepassword.frame.height + 15
        
        let boxSingupBut = UIView(frame: CGRect(x: scWid*0.15, y: hei, width: scWid*0.7, height: boxHei.height))
        boxSingupBut.layer.cornerRadius = 5
        boxSingupBut.backgroundColor = UIColor.darkGray
        boxSingupBut.alpha = 0.8
        signupButton = UIButton(frame: CGRect(x: scWid*0.17, y: hei, width: scWid*0.66, height: boxHei.height))
        signupButton.addTarget(self, action: #selector(signupAction), for: .touchUpInside)
        signupButton.setTitleColor(UIColor.white, for: .normal)
        
        let boxBack = UIView(frame: CGRect(x: 20, y: 70, width: scWid*0.3, height: scHei*0.04))
        boxBack.layer.cornerRadius = 5
        boxBack.backgroundColor = UIColor.darkGray
        boxBack.alpha = 0.8
        let backButton = UIButton(frame: CGRect(x: 0, y: 80, width: scWid*0.3, height: scHei*0.03))
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        backButton.setTitleColor(UIColor.white, for: .normal)
        
        username.placeholder = "Username"
        email.placeholder = "Email"
        password.placeholder = "Password"
        repassword.placeholder = " Re-password"
        signupButton.setTitle("Sign Up", for: .normal)
        backButton.setTitle("Back", for: .normal)
        
        loginView.addSubview(backButton)
        loginView.addSubview(logoAbac)
        loginView.addSubview(boxFacebook)
        loginView.addSubview(boxOr)
        loginView.addSubview(facbookBut)
        loginView.addSubview(boxUsername)
        loginView.addSubview(boxEmail)
        loginView.addSubview(boxPassword)
        loginView.addSubview(boxRepassword)
        loginView.addSubview(boxSingupBut)
        loginView.addSubview(username)
        loginView.addSubview(email)
        loginView.addSubview(password)
        loginView.addSubview(repassword)
        loginView.addSubview(signupButton)
    }
    
    func drawLoginPage(){
        self.signinPageStatus = true
        signupView = UIView(frame: CGRect(x: 0, y: 0, width: scWid, height: scHei))
        signupView.backgroundColor = UIColor.clear
        self.bg.addSubview(phoneBg)
        self.bg.addSubview(signupView)
        logoAbac = UIImageView(frame: CGRect(x: (scWid-(scHei*0.25))/2, y: scHei*0.15, width: scHei*0.25, height: scHei*0.25))
        logoAbac.image = UIImage(named: "abaclogo")
        var hei = logoAbac.frame.origin.y + logoAbac.frame.height + 40
        
        let boxHei = fm.calculateHeiFromString(text: "n/a", fontsize: fm.setFontSizeLight(fs: 27), tbWid: scWid*0.6)
        let boxFacebook = UIView(frame: CGRect(x: scWid*0.15, y: hei, width: scWid*0.7, height: boxHei.height))
        boxFacebook.layer.cornerRadius = 5
        boxFacebook.layer.borderColor = UIColor.white.cgColor
        boxFacebook.backgroundColor = UIColor.clear
        boxFacebook.alpha = 0.6
        facbookBut = FBSDKLoginButton(frame: CGRect(x: scWid*0.15, y: hei, width: scWid*0.7, height: boxHei.height))
        boxFacebook.addSubview(facbookBut)
        facbookBut.center = boxFacebook.center
        facbookBut.delegate = self
        facbookBut.readPermissions = ["public_profile","email"]
        hei = boxFacebook.frame.origin.y +  boxFacebook.frame.height + 5
        
        let boxOr = UILabel(frame: CGRect(x: scWid*0.15, y: hei, width: scWid*0.7, height: boxHei.height))
        boxOr.font = fm.setFontSizeLight(fs: 16)
        boxOr.textAlignment = .center
        boxOr.text = "or"
        
        hei = boxOr.frame.origin.y +  boxOr.frame.height + 5
        let boxUsername = UIView()
        boxUsername.frame = CGRect(x: scWid*0.15, y: hei, width: scWid*0.7, height: boxHei.height)
        boxUsername.layer.cornerRadius = 5
        boxUsername.backgroundColor = UIColor.white
        boxUsername.alpha = 0.8
        username = SkyFloatingLabelTextField()
        username.frame = CGRect(x: scWid*0.17, y: hei, width: scWid*0.66, height: boxHei.height)
        username.textColor = UIColor.black
        username.textAlignment = .center
        username.delegate = self
        username.font = fm.setFontSizeLight(fs: 14)
        username.text = ""
        username.placeholder = "Email"
        username.keyboardType = .emailAddress
        hei = boxUsername.frame.origin.y +  boxUsername.frame.height + 2
        
        let boxPassword = UIView(frame: CGRect(x: scWid*0.15, y: hei, width: scWid*0.7, height: boxHei.height))
        boxPassword.layer.cornerRadius = 5
        boxPassword.backgroundColor = UIColor.white
        boxPassword.alpha = 0.8
        password = SkyFloatingLabelTextField()
        password.frame = CGRect(x: scWid*0.17, y: hei, width: scWid*0.66, height: boxHei.height)
        password.textColor = UIColor.black
        password.isSecureTextEntry = true
        password.textAlignment = .center
        password.delegate = self
        password.font = fm.setFontSizeLight(fs: 14)
        password.text = ""
        password.placeholder = "Password"
        hei = password.frame.origin.y +  password.frame.height + 15
        
        let boxLogin = UIView(frame: CGRect(x: scWid*0.15, y: hei, width: scWid*0.7, height: boxHei.height))
        boxLogin.layer.cornerRadius = 5
        boxLogin.backgroundColor = UIColor.darkGray
        boxLogin.alpha = 0.8
        loginButton = UIButton(frame: CGRect(x: scWid*0.17, y: hei, width: scWid*0.66, height: boxHei.height))
        loginButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.setTitle("Login", for: .normal)
        hei = boxLogin.frame.origin.y +  boxLogin.frame.height + 10
        
        let boxSignup = UIView(frame: CGRect(x: scWid*0.15, y: hei, width: scWid*0.7, height: boxHei.height))
        boxSignup.layer.cornerRadius = 5
        boxSignup.backgroundColor = UIColor.darkGray
        boxSignup.alpha = 0.8
        signupButton = UIButton(frame: CGRect(x: scWid*0.17, y: hei, width: scWid*0.66, height: boxHei.height))
        signupButton.addTarget(self, action: #selector(signupPage), for: .touchUpInside)
        signupButton.setTitleColor(UIColor(red:84/225,green:201/225,blue:196/225,alpha:1), for: .normal)
        signupButton.setTitle("SignUp", for: .normal)
        hei = boxSignup.frame.origin.y +  boxSignup.frame.height + 10
        
        signupView.addSubview(logoAbac)
        signupView.addSubview(boxFacebook)
        signupView.addSubview(boxOr)
        signupView.addSubview(facbookBut)
        signupView.addSubview(boxUsername)
        signupView.addSubview(boxPassword)
        signupView.addSubview(boxLogin)
        signupView.addSubview(username)
        signupView.addSubview(password)
        signupView.addSubview(loginButton)
        signupView.addSubview(signupButton)
    }
    
    func Sidemenu() {
        if revealViewController() != nil {
            MenuButton.target = SWRevealViewController()
            MenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func CustomNavbar() {
        navigationController?.navigationBar.barTintColor = UIColor.red
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    
}


class UserCell : UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x:  56, y: (textLabel!.frame.origin.y - 2), width: (textLabel!.frame.width), height: (textLabel!.frame.height))
        detailTextLabel?.frame = CGRect(x: 56, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let profileImageView : UIImageView = {
        let piv = UIImageView()
        piv.image = UIImage(named: "User_Shield")
        piv.contentMode = .scaleAspectFill
        piv.translatesAutoresizingMaskIntoConstraints = false
        piv.layer.cornerRadius = 20
        piv.layer.masksToBounds = true
        return piv
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier:String?){
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    required init?(coder aDecorder : NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

