//
//  SuggestionController.swift
//  UIPSOPEC
//
//  Created by Popp on 4/17/17.
//  Copyright © 2017 Senior Project. All rights reserved.
//

import Foundation
import UIKit

class SuggestionTableViewController : UIViewController   {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button =  UIButton(type: .custom)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Suggestion", for: .normal)
        button.addTarget(self, action: #selector(self.buttonPressed(button:)), for: .touchUpInside)
        self.navigationItem.titleView = button
        
        
        navigationController?.navigationBar.barTintColor = UIColor.red

    }
    
    
    func buttonPressed(button: UIButton) {
        
        print("Click")
        
    }

}
