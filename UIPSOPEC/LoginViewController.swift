

import UIKit
import FBSDKLoginKit
import SystemConfiguration

 // width and height of current Scrren
let scWid = UIScreen.main.bounds.width
let scHei = UIScreen.main.bounds.height
let abacRed = UIColor(colorLiteralRed: 255/225, green: 0/225, blue: 0/225, alpha: 1)
class LoginViewController: UIViewController , FBSDKLoginButtonDelegate{
    
    var data:[String:AnyObject]!
    var userLoginDetail = UserLogInDetail()
    var text = ""
    var tokenn  = ""
    var udid = ""

    override func viewDidLoad() {
        super.viewDidLoad()
       
        CRUDProfileDevice.ClearProfileDevice()
//        let pfd = CRUDProfileDevice.GetUserProfile()
        
//        udid = (UIDevice.current.identifierForVendor?.uuidString)! as String
//            let loginButton = FBSDKLoginButton()
//            view.addSubview(loginButton)
//            loginButton.center = self.view.center
//            loginButton.readPermissions = ["public_profile","email"]
//            loginButton.delegate = self
        
        
//        if getProfileDevice() == nil {
//            let loginButton = FBSDKLoginButton()
//            view.addSubview(loginButton)
//            loginButton.center = self.view.center
//            loginButton.readPermissions = ["public_profile","email"]
//            loginButton.delegate = self
//        }else{
//            self.userLoginDetail = getProfileDevice()
//            print (getProfileDevice())
//            let vc = MessageTableViewController()
//            vc.profileDevice = self.userLoginDetail
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        
//        if !isInternetAvailable() {
//            toastNoInternet()
//        }
        
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
                print("Error: \(error)")
            }else{
               self.data = result as! [String : AnyObject]
                print(self.udid)
                self.userLoginDetail = UserLogInDetail(dic: self.data as AnyObject , token: self.tokenn,UDID:self.udid)
                CRUDProfileDevice.SaveProfileDevice(loginInfor: self.userLoginDetail)
                let pfd = CRUDProfileDevice.GetUserProfile()
                
                print("start profile device")
                print (pfd.email)
                print (pfd.facebookAccessToken)
                print (pfd.facebookId)
                print (pfd.facebookName)
                print (pfd.udid)
                print("*********************************************")
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
    
}
