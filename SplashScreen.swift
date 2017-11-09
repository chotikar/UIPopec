
import UIKit
import Foundation

class SplashScreen: UIViewController {
    
    let fm = FunctionMutual.self
    let AppLogo:UIImageView = {
       let al = UIImageView()
        al.frame = CGRect(x: 0.25*scWid, y: scHei/4, width: 0.5*scWid, height: 0.5*scWid)
        al.image = UIImage(named:"abaclogo")
        return al
    }()
    let vc = RevealViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = appColor
        self.view.addSubview(AppLogo)        
        if fm.isInternetAvailable() {
            self.performSegue(withIdentifier: "openSWL", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
