

import UIKit
import SystemConfiguration
import Foundation

class SplashScreen: UIViewController {
    
    let fm = FunctionMutual.self

    let AppLogo:UIImageView = {
       let al = UIImageView()
        al.frame = CGRect(x: 0.25*scWid, y: scHei/4, width: 0.5*scWid, height: 0.5*scWid)
        al.image = UIImage(named:"arts_logo")
        return al
    }()

    let vc = RevealViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = abacRed
        self.view.addSubview(AppLogo)
        
        if isInternetAvailable() {
            self.performSegue(withIdentifier: "openSWL", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
