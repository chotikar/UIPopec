


import UIKit
import SWRevealViewController

class RevealViewController: SWRevealViewController, SWRevealViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        self.tapGestureRecognizer()
        self.panGestureRecognizer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK : - SWRevealViewControllerDelegate
    
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        if position == FrontViewPosition.right {
            self.frontViewController.view.isUserInteractionEnabled = false
        }
        else {
            self.frontViewController.view.isUserInteractionEnabled = true
        }
    }
}
