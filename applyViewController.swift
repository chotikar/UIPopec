//
//  applyViewController.swift
//  UIPSOPEC
//
//  Created by Popp on 3/27/17.
//  Copyright © 2017 Senior Project. All rights reserved.
//

import Foundation
import SWRevealViewController

class applyViewController : UIViewController  {
    
    @IBOutlet weak var MenuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Sidemenu()
        CustomNavbar()
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
//    
//    func drawApply() -> CGFloat {
//        
//    }
}
