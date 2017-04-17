//
//  SuggestionController.swift
//  UIPSOPEC
//
//  Created by Popp on 4/17/17.
//  Copyright © 2017 Senior Project. All rights reserved.
//

import Foundation
import UIKit
import SWRevealViewController
class SuggestionTableViewController : UIViewController   {
    @IBOutlet weak var MenuButton: UIBarButtonItem!
    let  filterview = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        Sidemenu()
        CustomNavbar()
        
        let button =  UIButton(type: .custom)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Suggestion", for: .normal)
        button.addTarget(self, action: #selector(self.buttonPressed(button:)), for: .touchUpInside)
        self.navigationItem.titleView = button
        
        
        navigationController?.navigationBar.barTintColor = UIColor.red

    }

    func buttonPressed(button: UIButton) {
        filterview.frame  = CGRect(x: 60, y: 70, width: scWid * 0.7, height: scHei * 0.8)
        filterview.backgroundColor = UIColor.lightGray
        filterview.layer.borderWidth = 1
        filterview.layer.borderColor = UIColor.white.cgColor
        filterview.layer.cornerRadius = 5
        self.view.addSubview(filterview)
        
        filterview.isHidden = !filterview.isHidden
        
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
