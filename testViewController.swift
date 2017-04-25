//
//  testViewController.swift
//  UIPSOPEC
//
//  Created by Chotikar on 4/21/2560 BE.
//  Copyright © 2560 Senior Project. All rights reserved.
//

import UIKit

class testViewController: UIViewController {
    
    var testUser = UserLogInDetail()
    var toast : UIView!
    let fm = FunctionMutual.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        CRUDProfileDevice.ClearProfileDevice()
//        testUser.userId = 99998
//        testUser.email = "MooktestEmail.com"
//        testUser.facebookId = "MookFacebookId"
//        testUser.facebookName = "MookFacebookName"
//        testUser.facebookAccessToken = "MookFacebookAccessToken"
//        testUser.udid = "MookUDID"
//        testUser.username = "MookUsername"
//        testUser.password = "MookPassword"
//        testUser.result = ResultModle()
//        CRUDProfileDevice.SaveProfileDevice(loginInfor: testUser)
//        let k = CRUDProfileDevice.GetUserProfile()
//        print(k.userId)

            toast = fm.toast(message: "HELLO WORLD NAKAAA")
          self.view.addSubview(self.toast)
                    UIView.animate(withDuration: 1.8, delay: 0.0, options: [], animations: {
                        self.toast.backgroundColor = UIColor.darkGray
                    }, completion: { (finished: Bool) in
                        UIView.animate(withDuration: 2.5, delay: 0, options: [], animations: {
                            self.toast.backgroundColor = UIColor.clear
                           self.toast.isHidden = true
                        }, completion: nil)

                    })
    

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
