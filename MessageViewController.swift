
import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import SystemConfiguration
import SWRevealViewController
import SkyFloatingLabelTextField
import CoreData

let scWid = UIScreen.main.bounds.width
let scHei = UIScreen.main.bounds.height
let abacRed = UIColor(red: 22/225, green: 72/225, blue: 148/225, alpha: 1)

class MessageViewController: UIViewController , FBSDKLoginButtonDelegate , UITextFieldDelegate , UITableViewDelegate , UITableViewDataSource {
    @IBOutlet weak var MenuButton: UIBarButtonItem!
    var activityiIndicator: UIActivityIndicatorView! = UIActivityIndicatorView()
    let fm = FunctionMutual.self
    let ws = WebService.self
    let profileDb = CRUDProfileDevice.self
    let departmentDb = CRUDDepartmentMessage.self
    var userLoginInfor: UserLogInDetail!
    var loginBg: UIImageView = {
        var pb = UIImageView()
        pb.frame = CGRect(x: 0, y: 0, width: scWid, height: scHei)
        pb.contentMode = .scaleToFill
        pb.image = UIImage(named: "loginBG2")
        return pb
    }()
    var data: [String:AnyObject]!
    var actionView = UIView()
    ///Login Layout
    var logoAbac: UIImageView!
    var facbookBut: FBSDKLoginButton!
    var loginAndRegisBut: UIButton!
    var username: SkyFloatingLabelTextField!
    var password: SkyFloatingLabelTextField!
    var text = ""
    var tokenFacebook = ""
    ///Signup Layout
    var email:SkyFloatingLabelTextField!
    var rePassword: SkyFloatingLabelTextField!
    var signupView: UIView!
    var backBut: UIButton!
    ///Message Layout
    var logoutBut: UIBarButtonItem!
    var messageTableView: UITableView!
    var messageCell = "messageItemCell"
    var messageList: [MessageEntity]?
    /// Login and signUp
    var signinPageStatus: Bool!
    var toast: UIView!
    var userLoginModel = UserLogInDetail()
    var lang = CRUDSettingValue.GetUserSetting()
    var boxBack: UIView!
    var backButton: UIButton!
    var boxOr: UILabel!
    var boxUsername: UIView!
    var boxEmail: UIView!
    var boxPassword: UIView!
    var boxRepassword: UIView!
    var boxLoginAndRegis: UIView!
    var boxSignup: UIView!
    var signupButton = UIButton()
    var hei: CGFloat!
    var boxHei: CGRect!
    /// From Program Controller to go to Chat Controller
    var goToChatController = false
    var fromFacName: String!
    var fromDepEnName: String!
    var fromDepThName: String!
    var fromDepAbb: String!
    var fromFacId: String!
    var fromDepId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(actionView)
        CustomNavbar()
        Sidemenu()
        mangegeLayout()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.1
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.username || textField == self.password) {
            moveTextField(textField, moveDistance: -90, up: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == self.username || textField == self.password) {
            moveTextField(textField, moveDistance: -90, up: false)
        }
    }
    
    // MARK : MUTAL
    func mangegeLayout(){
    
        self.userLoginInfor = self.GetProfileDb()
        if self.userLoginInfor.userId == 0 {
            self.drawElementSignupLogin()
            self.drawLoginPage()
        }else{
            if goToChatController {
                let roomCode = "\(String(self.userLoginInfor.userId))\(fromFacId!)\(fromDepId!)"
                let departmentDb = self.SaveDepartmentDb(facName: fromFacName, facId: fromFacId, depNameEn: fromDepEnName, depId: fromDepId, depAbb: fromDepAbb, depNameTh: fromDepThName, roomCode: roomCode)
                if departmentDb.roomCode == nil {
                    drawMessagePage()
                }else{
                    let layout = UICollectionViewFlowLayout()
                    let chatLogController = ChatViewController(collectionViewLayout: layout)
                    chatLogController.departmentEntity =  departmentDb
                    goToChatController = false
                    self.navigationController?.pushViewController(chatLogController, animated: true)
                }
            }else{
                self.drawMessagePage()
            }
        }
    }
    
    // MARK: Webservice
    func signupWS(byfb: Int16, userDe: String, imageUrl: String){
        let udid = (UIDevice.current.identifierForVendor?.uuidString)! as String
        ws.sentSignUpWS(byfacebook: Int(byfb), userDetail: userDe, deviceId: udid, imageUrl:imageUrl ) { (responseData: UserLogInDetail, nil) in
            DispatchQueue.main.async( execute: {
                let userFromWs = responseData
                if userFromWs.userId == 0 {
                    self.toastMessage(mess: userFromWs.result.message)
                }else{
                    print("Signup Success")
                    self.SaveProfileDb(loginInfor: userFromWs)
                    self.mangegeLayout()
                }
                self.stopIndicator()
            })
        }
    }
    
    func loginWS(byfb: Int16, userDe: String){
        let udid = (UIDevice.current.identifierForVendor?.uuidString)! as String
        ws.sentSignInWS(byfacebook: Int(byfb), userDetail: userDe, deviceId: udid) { (responseData: UserLogInDetail, nil) in
            DispatchQueue.main.async( execute: {
                let userFromWs = responseData
                if userFromWs.userId == 0 {
                    let manage = FBSDKLoginManager()
                    manage.logOut()
                    FBSDKAccessToken.setCurrent(nil)
                    FBSDKProfile.setCurrent(nil)
                    self.toastMessage(mess: userFromWs.result.message)
                }else{
                    self.ClearProfileDb()
                    self.SaveProfileDb(loginInfor: userFromWs)
                    let tr = self.GetProfileDb()
                    print("GetValueWhen Login :\(tr.userId)")
                    self.mangegeLayout()
                }
                self.stopIndicator()
            })
        }
    }
    
    // MARK: Toast
    func toastMessage(mess:String){
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
        if password.text == rePassword.text && username.text != "" && email.text != "" {
                let ud = "\(username.text!);\(password.text!);\(email.text!)"
                print(ud)
                startIndicator()
                signupWS(byfb: 0, userDe: ud, imageUrl: "N/A")
        }else{
            toastMessage(mess: "Invalid input")
        }
    }
    
    func signInAction(sender : AnyObject){
        if password.text != "" && username.text != "" {
                let ud = "N/A;\(password.text!);\(username.text!)"
                startIndicator()
                loginWS(byfb: 0, userDe: ud)
        }else{
            toastMessage(mess: "Invalid input")
        }
    }
    
    func logOutAction(sender : UIBarButtonItem){
        if self.userLoginInfor.byFacebook == 1{
            let manage = FBSDKLoginManager()
            manage.logOut()
            FBSDKAccessToken.setCurrent(nil)
            FBSDKProfile.setCurrent(nil)
        }
        departmentDb.ClearMessageAndDepartment()
        self.ClearProfileDb()
        self.SaveProfileDb(loginInfor: UserLogInDetail())
        drawElementSignupLogin()
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
            tokenFacebook = (accessToken?.tokenString ?? "")!
            print(tokenFacebook)
        }
        let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil){
                print("Error: \(error as! String)")
            }else{
                self.data = result as! [String : AnyObject]
                print(self.data)
                //1304007822985652
                //http://graph.facebook.com/1304007822985652/picture?type=large&redirect=true&width=500&height=500
                let facPic = "http://graph.facebook.com/\(self.data["id"] as! String)/picture?type=large&redirect=true&width=300&height=300"
                if self.signinPageStatus {
                    self.loginWS(byfb: 1, userDe: "\(self.data["first_name"] as! String);\(self.data["id"] as! String);\(self.tokenFacebook)")
                }else{
                    self.signupWS(byfb: 1, userDe: "\(self.data["first_name"] as! String);\(self.data["id"] as! String);0", imageUrl:facPic )
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
        if let count = messageList?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UserCell()
        if let messageDe = messageList?[indexPath.row] {
        cell.title.text = messageDe.department?.programNameEn
        print("Time (\(indexPath.row)):\(messageDe.date!)")
        cell.timeLable.text = self.SetDateFormatter(date: (messageDe.date!) as Date)
        cell.message.text = messageDe.text!
        cell.profileImageView.image = UIImage(named:(messageDe.department?.programAbb)!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (scHei * 0.15)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        let chatLogController = ChatViewController(collectionViewLayout: layout)
        chatLogController.departmentEntity = messageList?[indexPath.row].department
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        DeleteDepartmentByRoomCode(roomCode: (messageList![indexPath.row].department?.roomCode)!)
        loadData()
    }
        
    func SetDateFormatter(date: Date) -> String {
        let calendar = NSCalendar.autoupdatingCurrent
        let dateFormatter = DateFormatter()
        if calendar.isDateInToday(date) {
            dateFormatter.dateFormat = "H:mm"
            return dateFormatter.string(from: date as Date)
        }else {
            if calendar.isDateInYesterday(date as Date){
                return "Yesterday"
            }else{
                dateFormatter.dateFormat = "MMMM dd yyyy"
                return dateFormatter.string(from: date as Date)
            }
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
    
    func GetProfileDb() -> UserLogInDetail {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProfileInforEntity")
        var userProfile = UserLogInDetail()
        var profileValue_DB =  [NSManagedObject]()
        do {
            let result = try managedContext.fetch(fetchRequest)
            profileValue_DB = result
            if (profileValue_DB as? [NSManagedObject]) != nil {
                if profileValue_DB.first?.value(forKey: "byFacebook") as? Int16 != nil {
                    userProfile = UserLogInDetail(obj: profileValue_DB)
                }else{
                    userProfile = UserLogInDetail()
                }
            } else {
                print("Error null")
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return userProfile
    }
    
    func SaveProfileDb(loginInfor: UserLogInDetail){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context =  appDelegate.persistentContainer.viewContext
        let entity =  NSEntityDescription.entity(forEntityName: "ProfileInforEntity", in: context)
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        transc.setValue(loginInfor.byFacebook, forKey: "byFacebook")
        transc.setValue(loginInfor.email, forKey: "email")
        transc.setValue(loginInfor.facebookId, forKey: "facebook_id")
        transc.setValue(loginInfor.facebookName, forKey: "facebook_name")
        transc.setValue(loginInfor.facebookAccessToken, forKey: "facebook_access_token")
        transc.setValue(loginInfor.udid, forKey: "udid_device")
        transc.setValue(loginInfor.username, forKey: "username")
        transc.setValue(loginInfor.password, forKey: "password")
        transc.setValue(loginInfor.userId, forKey: "userId")
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mangegeLayout()
    }
    
    func ClearProfileDb(){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ProfileInforEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try delegate.saveContext()
        } catch {
            print ("There was an error")
        }
    }
    
    func SaveDepartmentDb(facName: String, facId: String, depNameEn: String, depId: String, depAbb: String, depNameTh: String, roomCode: String) -> DepartmentEntity {
        let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var department = FindExistDepartment(roomCode: roomCode)
        if department.roomCode == nil {
            department.facultyId = facId
            department.facultyName = facName
            department.programAbb = depAbb
            department.programeNameTh = depNameTh
            department.programNameEn = depNameEn
            department.programId = depId
            department.roomCode = roomCode
            do{
                try (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }catch let err {
                print(err)
            }
        }
        return department
    }
    
    func FindExistDepartment(roomCode: String) -> DepartmentEntity {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var departmentList: [DepartmentEntity] = []
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DepartmentEntity")
        do {
            departmentList =  try context.fetch(fetchRequest) as! [DepartmentEntity]
        }catch let err {
            print("Error: \(err), From CRUDDepartment/FindDepartment(roomCode)")
        }
        
        for dep in departmentList {
            if dep.roomCode == roomCode {
                return dep
            }
        }
        return DepartmentEntity(context: context)
    }
    
    func DeleteDepartmentByRoomCode(roomCode: String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var departmentList: [DepartmentEntity] = []
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DepartmentEntity")
        do {
            departmentList =  try context.fetch(fetchRequest) as! [DepartmentEntity]
            for department in departmentList {
                if department.roomCode == roomCode {
                for message in department.message! {
                    context.delete(message as! NSManagedObject)
                }
                context.delete(department)
                }
            }
            try context.save()
        }catch let err {
            print("Error: \(err), From CRUDDepartment/FindDepartment(roomCode)")
        }
    }

    func drawMessagePage(){
        self.navigationItem.title = lang == "E" ? "Chat" : "คุยกับเจ้าหน้าที่"
        messageTableView = UITableView(frame: CGRect(x: 0, y: 0, width: scWid, height: scHei))
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTableView.register(UserCell.self, forCellReuseIdentifier: messageCell)
        messageTableView.allowsSelectionDuringEditing = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: lang == "E" ? "Logout" : "ล๊อกเอ้าท์", style: .plain, target: self, action: #selector(logOutAction(sender:)))
        self.view.backgroundColor = UIColor.white
        self.startIndicator()
        self.view.addSubview(messageTableView)
        loadData()
    }
    
    private func fetchDepartmentMessage() -> [DepartmentEntity] {
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let context = appDelegate.persistentContainer.viewContext
        var departmentList : [DepartmentEntity] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DepartmentEntity")
            do{
                departmentList = try context.fetch(request) as! [DepartmentEntity]
            }catch let err {
                print(err)
            }
        return departmentList
    }
    
    func loadData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        messageList = [MessageEntity]()
        let friends = fetchDepartmentMessage()
        if friends.count > 0 {
            for friend in friends {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MessageEntity")
                request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                request.predicate = NSPredicate(format: "department.roomCode = %@", friend.roomCode! as String)
                request.fetchLimit = 1
                    do{
                        let fetchMessage = try context.fetch(request) as? [MessageEntity]
                        for i in fetchMessage! {
                           messageList?.append(i)
                        }
                    }catch let err {
                        print(err)
                    }
            messageList = messageList?.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedDescending})
            }
        }
        self.stopIndicator()
        self.messageTableView.reloadData()
    }
   
    func drawSignupPage(){
        boxBack.center = CGPoint(x: scWid * 0.2, y: scHei * 0.03)
        hei = logoAbac.frame.origin.y + logoAbac.frame.height + 30
        facbookBut.center = CGPoint(x: scWid * 0.5, y: hei)
        hei = facbookBut.frame.origin.y +  facbookBut.frame.height + 20
        boxOr.center = CGPoint(x: scWid * 0.5, y: hei)
        hei = boxOr.frame.origin.y +  boxOr.frame.height + 20
        boxUsername.center = CGPoint(x: scWid * 0.5, y: hei)
        hei = boxUsername.frame.origin.y +  boxUsername.frame.height + 20
        boxEmail.center = CGPoint(x: scWid * 0.5, y: hei)
        hei = boxEmail.frame.origin.y +  boxEmail.frame.height + 20
        boxPassword.center = CGPoint(x: scWid * 0.5, y: hei)
        hei = boxPassword.frame.origin.y +  boxPassword.frame.height + 20
        boxRepassword.center = CGPoint(x: scWid * 0.5, y: hei)
        hei = boxRepassword.frame.origin.y +  boxRepassword.frame.height + 30
        boxLoginAndRegis.center = CGPoint(x: scWid * 0.5, y: hei)
        loginAndRegisBut.addTarget(self, action: #selector(signupAction), for: .touchUpInside)
        loginAndRegisBut.setTitle("Register", for: .normal)
        self.view.addSubview(loginBg)
        self.view.addSubview(boxBack)
        self.view.addSubview(logoAbac)
        self.view.addSubview(facbookBut)
        self.view.addSubview(boxOr)
        self.view.addSubview(boxUsername)
        self.view.addSubview(boxEmail)
        self.view.addSubview(boxPassword)
        self.view.addSubview(boxRepassword)
        self.view.addSubview(boxLoginAndRegis)
    }
    
    func drawLoginPage(){
        hei = logoAbac.frame.origin.y + logoAbac.frame.height + 40
        facbookBut.center = CGPoint(x: scWid*0.5, y: hei)
        hei = facbookBut.frame.origin.y +  facbookBut.frame.height + 20
        boxOr.center = CGPoint(x: scWid*0.5, y: hei)
        hei = boxOr.frame.origin.y +  boxOr.frame.height + 20
        boxUsername.center = CGPoint(x: scWid*0.5, y: hei)
        hei = boxUsername.frame.origin.y +  boxUsername.frame.height + 40
        boxPassword.center = CGPoint(x: scWid*0.5, y: hei)
        hei = boxPassword.frame.origin.y +  boxPassword.frame.height + 30
        boxLoginAndRegis.center = CGPoint(x: scWid*0.5, y: hei)
        loginAndRegisBut.addTarget(self, action: #selector(signInAction), for: .touchUpInside)
        loginAndRegisBut.setTitle("Login", for: .normal)
        hei = boxLoginAndRegis.frame.origin.y +  boxLoginAndRegis.frame.height + 20
        boxSignup.center = CGPoint(x: scWid*0.5, y: hei)
        self.view.addSubview(loginBg)
        self.view.addSubview(logoAbac)
        self.view.addSubview(boxOr)
        self.view.addSubview(facbookBut)
        self.view.addSubview(boxUsername)
        self.view.addSubview(boxPassword)
        self.view.addSubview(boxLoginAndRegis)
        self.view.addSubview(boxSignup)
    }
    
    func drawElementSignupLogin(){
        logoAbac = UIImageView(frame: CGRect(x: (scWid-(scHei*0.25))/2, y: scHei*0.05, width: scHei*0.25, height: scHei*0.25))
        logoAbac.image = UIImage(named: "abaclogo")
        boxHei = fm.calculateHeiFromString(text: "n/a", fontsize: 27, tbWid: scWid*0.6)
        boxBack = UIView(frame: CGRect(x: 0, y: 0, width: scWid*0.3, height: scHei*0.04))
        boxBack.layer.cornerRadius = 5
        boxBack.backgroundColor = UIColor.darkGray
        boxBack.alpha = 0.8
        backButton = UIButton(frame: CGRect(x: 0, y: 0, width: scWid*0.3, height: scHei*0.04))
        backButton.addTarget(self, action: #selector(drawLoginPage), for: .touchUpInside)
        backButton.setTitleColor(UIColor.white, for: .normal)
        backButton.setTitle("Back", for: .normal)
        boxBack.addSubview(backButton)
        facbookBut = FBSDKLoginButton(frame: CGRect(x: 0, y: 0, width: scWid*0.7, height: boxHei.height))
        facbookBut.delegate = self
        facbookBut.readPermissions = ["public_profile","email"]
        boxOr = UILabel(frame: CGRect(x: 0, y: 0, width: scWid*0.7, height: boxHei.height))
        boxOr.font = fm.setFontSizeLight(fs: 16)
        boxOr.textAlignment = .center
        boxOr.text = "or"
        boxUsername = UIView(frame: CGRect(x: 0, y: 0, width: scWid*0.7, height: boxHei.height))
        boxUsername.layer.cornerRadius = 5
        boxUsername.backgroundColor = UIColor.white
        boxUsername.alpha = 0.7
        username = SkyFloatingLabelTextField(frame: CGRect(x: 0, y: 0, width: scWid*0.7, height: boxHei.height))
        username.textColor = UIColor.black
        username.autocapitalizationType = .none
        username.textAlignment = .center
        username.delegate = self
        username.font = fm.setFontSizeLight(fs: 14)
        username.keyboardType = .emailAddress
        boxUsername.addSubview(username)
        boxEmail = UIView(frame: CGRect(x: 0, y: 0, width: scWid*0.7, height: boxHei.height))
        boxEmail.layer.cornerRadius = 5
        boxEmail.backgroundColor = UIColor.white
        boxEmail.alpha = 0.7
        email = SkyFloatingLabelTextField(frame: CGRect(x: 0, y: 0, width: scWid*0.7, height: boxHei.height))
        email.textColor = UIColor.black
        email.textAlignment = .center
        email.delegate = self
        email.font = fm.setFontSizeLight(fs: 14)
        email.keyboardType = .emailAddress
        boxEmail.addSubview(email)
        boxPassword = UIView(frame: CGRect(x: 0, y: 0, width: scWid*0.7, height: boxHei.height))
        boxPassword.layer.cornerRadius = 5
        boxPassword.backgroundColor = UIColor.white
        boxPassword.alpha = 0.7
        password = SkyFloatingLabelTextField(frame: CGRect(x: 0, y: 0, width: scWid*0.7, height: boxHei.height))
        password.textColor = UIColor.black
        password.textAlignment = .center
        password.isSecureTextEntry = true
        password.delegate = self
        password.font = fm.setFontSizeLight(fs: 14)
        boxPassword.addSubview(password)
        boxRepassword = UIView(frame: CGRect(x: 0, y: 0, width: scWid*0.7, height: boxHei.height))
        boxRepassword.layer.cornerRadius = 5
        boxRepassword.backgroundColor = UIColor.white
        boxRepassword.alpha = 0.8
        rePassword = SkyFloatingLabelTextField(frame: CGRect(x: 0, y: 0, width: scWid*0.7, height: boxHei.height))
        rePassword.textColor = UIColor.black
        rePassword.isSecureTextEntry = true
        rePassword.textAlignment = .center
        rePassword.delegate = self
        rePassword.font = fm.setFontSizeLight(fs: 14)
        boxRepassword.addSubview(rePassword)
        boxLoginAndRegis = UIView(frame: CGRect(x: 0, y: 0, width: scWid*0.7, height: boxHei.height))
        boxLoginAndRegis.layer.cornerRadius = 5
        boxLoginAndRegis.backgroundColor = UIColor.darkGray
        boxLoginAndRegis.alpha = 0.8
        loginAndRegisBut = UIButton(frame: CGRect(x: 0, y: 0, width: scWid*0.7, height: boxHei.height))
        loginAndRegisBut.setTitleColor(UIColor.white, for: .normal)
        boxLoginAndRegis.addSubview(loginAndRegisBut)
        boxSignup = UIView(frame: CGRect(x: 0, y: 0, width: scWid*0.7, height: boxHei.height))
        boxSignup.layer.cornerRadius = 5
        boxSignup.backgroundColor = UIColor.darkGray
        boxSignup.alpha = 0.8
        signupButton = UIButton(frame: CGRect(x: 0, y: 0, width: scWid*0.7, height: boxHei.height))
        signupButton.addTarget(self, action: #selector(drawSignupPage), for: .touchUpInside)
        signupButton.setTitleColor(UIColor(red:84/225, green:201/225, blue:196/225, alpha:1), for: .normal)
        signupButton.setTitle("SignUp", for: .normal)
        boxSignup.addSubview(signupButton)
        username.placeholder = "Username"
        email.placeholder = "Email"
        password.placeholder = "Password"
        rePassword.placeholder = " Re-password"
        backButton.setTitle("Back", for: .normal)
        self.view.addSubview(loginBg)
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
    
    func Sidemenu() {
        MenuButton.target = SWRevealViewController()
        MenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
    }
    
    func CustomNavbar() {
        navigationController?.navigationBar.barTintColor = abacRed
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
}
