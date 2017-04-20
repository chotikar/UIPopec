

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import SystemConfiguration
import SWRevealViewController

 // width and height of current Scrren
let scWid = UIScreen.main.bounds.width
let scHei = UIScreen.main.bounds.height
let abacRed = UIColor(colorLiteralRed: 255/225, green: 0/225, blue: 0/225, alpha: 1)

class LoginViewController: UIViewController , FBSDKLoginButtonDelegate , UITextFieldDelegate , UITableViewDelegate , UITableViewDataSource {

 
    let fm = FunctionMutual.self
    let ws = WebService.self
    @IBOutlet weak var MenuButton: UIBarButtonItem!
    var data:[String:AnyObject]!
    var userLoginInfor : UserLogInDetail!
    var text = ""
    var tokenn  = ""
    
    var phoneBg : UIImageView = {
       var pb = UIImageView()
        pb.frame = CGRect(x: 0, y: 0, width: scWid, height: scHei)
//        pb.backgroundColor = UIColor(patternImage: UIImage(named:"loginBG2")!)
        pb.contentMode = .scaleToFill
        pb.image = UIImage(named: "loginBG2")
        return pb
    }()
    var loginView : UIView = {
        var pb = UIView()
        pb.frame = CGRect(x: 0, y: 0, width: scWid, height: scHei)
        pb.backgroundColor = UIColor.clear
        return pb
    }()
    var messageView : UIView = {
        var pb = UIView()
        pb.frame = CGRect(x: 0, y: 0, width: scWid, height: scHei)
        pb.backgroundColor = UIColor.white
        return pb
    }()
    
    var logoAbac : UIImageView!
    
    var loginButton : UIButton!
    var username : UITextField!
    var password : UITextField!
    
    var signupView : UIView = {
        var pb = UIView()
        pb.frame = CGRect(x: 0, y: 0, width: scWid, height: scHei)
        pb.backgroundColor = UIColor.clear
        return pb
    }()
    var signupButton : UIButton!
    var email:UITextField!
    var repassword : UITextField!
    var backBut : UIButton!
    
    var facbookBut : FBSDKLoginButton!
    
    /////////////////////MessageList
    var messageTableView : UITableView!
    var messageCell = "messageItemCell"
    var messageList = [MessageModel]
    override func viewWillAppear(_ animated: Bool) {
        drawLoginPage()
//        self.userLoginInfor = CRUDProfileDevice.GetUserProfile()
//        if self.userLoginInfor.type == 0 {
//            self.goToMessage(status: false)
//        }else{
//             self.goToMessage(status: true)
//        }
    }
    var url = UserLogInDetail()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        Sidemenu()
        CustomNavbar()
//        url.username = "Mook Test"
//        url.type = 1
//        CRUDProfileDevice.SaveProfileDevice(loginInfor: url)
        print(CRUDProfileDevice.GetUserProfile().username)
//        let pfd = CRUDProfileDevice.GetUserProfile()
        
//        udid = (UIDevice.current.identifierForVendor?.uuidString)! as String
//            let loginButton = FBSDKLoginButton()
//            view.addSubview(loginButton)
//            loginButton.center = self.view.center
//            facbookBut.readPermissions = ["public_profile","email"]
//            facbookBut.delegate = self
        
        
//        if getProfileDevice() == nil {
//            let loginButton = FBSDKLoginButton()
//            view.addSubview(loginButton)
//            loginButton.center = self.view.center
//            loginButton.readPermissions = ["public_profile","email"]
//            loginButton.delegate = self
//        }else{
//            self.userLoginDetail  getProfileDevice()
//            print (getProfileDevice())
//            let vc = MessageTableViewController()
//            vc.profileDevice = self.userLoginDetail
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        
//        if !isInternetAvailable() {
//            toastNoInternet()
//        }
        
    }
    
    // MARK : MUTAL
    
    func sentLoginSignupWS(byfb: Int16, userDe: String, imageUrl: String){
        let udid = (UIDevice.current.identifierForVendor?.uuidString)! as String
        ws.sentLoginInformationWS(byfacebook: Int(byfb), userDetail: userDe, deviceId: udid, imageUrl:imageUrl ) { (responseData: UserLogInDetail, nil) in
            DispatchQueue.main.async( execute: {
                self.userLoginInfor = responseData
                if self.userLoginInfor.type != 0 {
                    //TODO: message list
                }
            })
        }
    }
    
    func goToMessage(status : Bool){
        if status {
            self.drawMessagePage()
            
        }else{
            self.drawLoginPage()
        }
    }
    
    // MARK: SignUp
    func signupAction() ->Int16 {
        //0 == incorect password
        //1 == correct password
        if password.text == repassword.text {
            if username.text != "" && email.text != "" {
                let ud = "\(username.text);\(password.text)\(email.text)"
            sentLoginSignupWS(byfb: 0, userDe: ud, imageUrl: "N/A")
            return 1
            }else {
                return 0
            }
        }else{
            return 0
        }
    }

    
    // MARK: LogIn
    func signupPage(){
        self.drawSignupPage()
    }
    
    func signIn(sender : AnyObject){
        self.goToMessage(status: true)
    }
    
   
   // MARK: Message
    func getMessageListWs(){
//        ws.sentLoginInformationWS(byfacebook: Int(byfb), userDetail: userDe, deviceId: udid, imageUrl:imageUrl ) { (responseData: UserLogInDetail, nil) in
//            DispatchQueue.main.async( execute: {
//                self.userLoginInfor = responseData
//                if self.userLoginInfor.type != 0 {
//                    //TODO: message list
//                }
//            })
//        }

    }
    
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: messageCell, for: indexPath)
        cell.textLabel?.text = "Dummy message"
        cell.detailTextLabel?.text = "Detail dummy messagekllllksdkwkenxmewkdojwememopdkeopkdpwokeod"
        cell.detailTextLabel?.textColor = UIColor.darkGray
        //        cell.imageView?.loadImageUsingCacheWithUrlString(urlStr: "http://static1.squarespace.com/static/525f350ee4b0fd74e5ba0495/t/53314e2be4b00782251d9427/1481141044684/?format=1500w")
        cell.imageView?.contentMode = .scaleAspectFill
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (scHei * 0.11)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chatLogController = ChatLogCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.roomCode = "1234"
        navigationController?.pushViewController(chatLogController, animated: true)
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
            // print(accessToken?.tokenString ?? 00000000000) //000000000 is Default Value
             tokenn = (accessToken?.tokenString)!
        }
        
        //--------This Part Print Picture, Email, Id, FirstName--------
        
        let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name,email, picture.type(large)"])
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil){
                print("Error: \(error as! String)")
            }else{
               self.data = result as! [String : AnyObject]
                 print(self.data)
//                print(self.udid)
                //self.userLoginInfor = UserLogInDetail(dic: self.data as AnyObject , token: self.tokenn,UDID:self.udid)
              //  CRUDProfileDevice.SaveProfileDevice(loginInfor: self.userLoginDetail)
//                let pfd = CRUDProfileDevice.GetUserProfile()
//                
//                print("start profile device")
//                print (pfd.email)
//                print (pfd.facebookAccessToken)
//                print (pfd.facebookId)
//                print (pfd.facebookName)
//                print (pfd.udid)
//                print("*********************************************")
            }
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logout Successful")
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

    func toastNoInternet(){
        let toastLabel = UILabel(frame: CGRect(x: (scWid/2)-150, y: scHei*0.85, width: 300, height: 30))
        toastLabel.backgroundColor = UIColor.darkGray
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = NSTextAlignment.center;
        self.view.addSubview(toastLabel)
        toastLabel.text = "No Internet Connection"
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        UIView.animate(withDuration: 4.0, delay: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        })
    }
    
    func drawMessagePage(){
        messageTableView = UITableView(frame: CGRect(x: 0, y: 0, width: scWid, height: scHei))
        self.view.addSubview(messageView)
        self.messageView.addSubview(messageTableView)
        messageTableView.delegate = self
        messageTableView.dataSource = self
//        messageTableView.scrollIndicatorInsets.bottom
            //.scrollToRow(at: , at: UITableViewScrollPosition.bottom, animated: true)
        messageTableView.register(UserCell.self, forCellReuseIdentifier: messageCell)
    }
    
    func drawSignupPage(){
        logoAbac = UIImageView(frame: CGRect(x: (scWid-(scHei*0.25))/2, y: scHei*0.15, width: scHei*0.25, height: scHei*0.25))
        logoAbac.image = UIImage(named: "abaclogo")
        var hei = logoAbac.frame.origin.y + logoAbac.frame.height + 20
        
        var boxHei = fm.calculateHeiFromString(text: "n/a", fontsize: fm.setFontSizeLight(fs: 27), tbWid: scWid*0.6)
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
        username = UITextField(frame: CGRect(x: scWid*0.17, y: hei, width: scWid*0.66, height: boxHei.height))
        username.textColor = UIColor.black
        username.textAlignment = .center
        username.delegate = self
        username.font = fm.setFontSizeLight(fs: 14)
        username.placeholder = "Username"
        username.keyboardType = .emailAddress
        hei = boxUsername.frame.origin.y +  boxUsername.frame.height + 10
        
        let boxEmail = UIView(frame: CGRect(x: scWid*0.15, y: hei, width: scWid*0.7, height: boxHei.height))
        boxEmail.layer.cornerRadius = 5
        boxEmail.backgroundColor = UIColor.white
        boxEmail.alpha = 0.7
        email = UITextField(frame: CGRect(x: scWid*0.17, y: hei, width: scWid*0.66, height: boxHei.height))
        email.textColor = UIColor.black
        email.textAlignment = .center
        email.delegate = self
        email.font = fm.setFontSizeLight(fs: 14)
        email.placeholder = "Email"
        email.keyboardType = .emailAddress
        hei = boxEmail.frame.origin.y +  boxEmail.frame.height + 10

        
        let boxPassword = UIView(frame: CGRect(x: scWid*0.15, y: hei, width: scWid*0.7, height: boxHei.height))
        boxPassword.layer.cornerRadius = 5
        boxPassword.backgroundColor = UIColor.white
        boxPassword.alpha = 0.7
        password = UITextField(frame: CGRect(x: scWid*0.17, y: hei, width: scWid*0.66, height: boxHei.height))
        password.textColor = UIColor.black
        password.textAlignment = .center
        password.delegate = self
        password.font = fm.setFontSizeLight(fs: 14)
        password.placeholder = "Password"
        hei = password.frame.origin.y +  password.frame.height + 2
        
        let boxRepassword = UIView(frame: CGRect(x: scWid*0.15, y: hei, width: scWid*0.7, height: boxHei.height))
        boxRepassword.layer.cornerRadius = 5
        boxRepassword.backgroundColor = UIColor.white
        boxRepassword.alpha = 0.8
        repassword = UITextField(frame: CGRect(x: scWid*0.17, y: hei, width: scWid*0.66, height: boxHei.height))
        repassword.textColor = UIColor.black
        repassword.textAlignment = .center
        repassword.delegate = self
        repassword.font = fm.setFontSizeLight(fs: 14)
        repassword.placeholder = " Re-password"
        hei = boxRepassword.frame.origin.y +  boxRepassword.frame.height + 15
        
        let boxSingupBut = UIView(frame: CGRect(x: scWid*0.15, y: hei, width: scWid*0.7, height: boxHei.height))
        boxSingupBut.layer.cornerRadius = 5
        boxSingupBut.backgroundColor = UIColor.darkGray
        boxSingupBut.alpha = 0.8
        signupButton = UIButton(frame: CGRect(x: scWid*0.17, y: hei, width: scWid*0.66, height: boxHei.height))
        signupButton.addTarget(self, action: #selector(signupAction), for: .touchUpInside)
        signupButton.setTitleColor(UIColor.white, for: .normal)
        signupButton.setTitle("Sign Up", for: .normal)
        
        
        self.view.addSubview(phoneBg)
        self.view.addSubview(loginView)
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
        logoAbac = UIImageView(frame: CGRect(x: (scWid-(scHei*0.25))/2, y: scHei*0.15, width: scHei*0.25, height: scHei*0.25))
        logoAbac.image = UIImage(named: "abaclogo")
        var hei = logoAbac.frame.origin.y + logoAbac.frame.height + 40
        
        var boxHei = fm.calculateHeiFromString(text: "n/a", fontsize: fm.setFontSizeLight(fs: 27), tbWid: scWid*0.6)
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
        boxUsername.alpha = 0.8
        username = UITextField(frame: CGRect(x: scWid*0.17, y: hei, width: scWid*0.66, height: boxHei.height))
        username.textColor = UIColor.black
        username.textAlignment = .center
        username.delegate = self
        username.font = fm.setFontSizeLight(fs: 14)
        username.placeholder = "Username"
        username.keyboardType = .emailAddress
        hei = boxUsername.frame.origin.y +  boxUsername.frame.height + 2
        
        let boxPassword = UIView(frame: CGRect(x: scWid*0.15, y: hei, width: scWid*0.7, height: boxHei.height))
        boxPassword.layer.cornerRadius = 5
        boxPassword.backgroundColor = UIColor.white
        boxPassword.alpha = 0.8
        password = UITextField(frame: CGRect(x: scWid*0.17, y: hei, width: scWid*0.66, height: boxHei.height))
        password.textColor = UIColor.black
        password.textAlignment = .center
        password.delegate = self
        password.font = fm.setFontSizeLight(fs: 14)
        password.placeholder = "Password"
        hei = password.frame.origin.y +  password.frame.height + 15
        
        
        let boxLogin = UIView(frame: CGRect(x: scWid*0.15, y: hei, width: scWid*0.7, height: boxHei.height))
        boxLogin.layer.cornerRadius = 5
        boxLogin.backgroundColor = UIColor.darkGray
        boxLogin.alpha = 0.8
        loginButton = UIButton(frame: CGRect(x: scWid*0.17, y: hei, width: scWid*0.66, height: boxHei.height))
        loginButton.addTarget(self, action: #selector(sentLoginSignupWS), for: .touchUpInside)
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
        
        
        self.view.addSubview(phoneBg)
        self.view.addSubview(signupView)
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
    
}





class UserCell : UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x:  56, y: (textLabel!.frame.origin.y - 2), width: (textLabel!.frame.width), height: (textLabel!.frame.height))
        detailTextLabel?.frame = CGRect(x: 56, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let profileImageView : UIImageView = {
        let piv = UIImageView()
        //        piv.image = (UIImage(named: "User_Shield"))
        piv.contentMode = .scaleAspectFill
        piv.translatesAutoresizingMaskIntoConstraints = false
        piv.layer.cornerRadius = 20
        piv.layer.masksToBounds = true
        piv.backgroundColor = UIColor.brown
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

