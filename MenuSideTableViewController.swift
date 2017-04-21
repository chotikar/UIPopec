//
//  MenuSideTableViewController.swift
//  UIPSOPEC
//
//  Created by Popp on 4/20/17.
//  Copyright © 2017 Senior Project. All rights reserved.
//

import Foundation
import UIKit

class MenuSideTableViewController: UITableViewController {
    
    @IBOutlet var Menutable : UITableView!
    @IBAction func langSwitch(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            CRUDSettingValue.UpdateSetting(lang: "E")
            language.text = "Language"
            news.text = "News"
            faculty.text = "Faculty"
            map.text = "Map"
            calendar.text = "Calendar"
            apply.text = "Apply"
            recommend.text = "Program Recommendation"
            chat.text = "Chat"
            contact.text = "Contact Us"
            print ("eng")
        }else {
            CRUDSettingValue.UpdateSetting(lang: "T")
            language.text = "เปลี่ยนภาษา"
            news.text = "ข่าวสาร"
            faculty.text = "คณะ"
            map.text = "แผนที่"
            calendar.text = "ปฏิทิน"
            apply.text = "สมัครเรียน"
            recommend.text = "แนะนำหลักสูตร"
            chat.text = "คุยกับเจ้าหน้าที่"
            contact.text = "ติดต่อ"
             print ("Thai")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Menutable.separatorStyle = .none
//        Menutable.backgroundColor = UIColor.red
        self.navigationController?.navigationBar.isTranslucent = true
        
    }
    
    @IBOutlet var image:UIImage!
    @IBOutlet var language:UILabel!
    @IBOutlet var news:UILabel!
    @IBOutlet var faculty:UILabel!
    @IBOutlet var map:UILabel!
    @IBOutlet var calendar:UILabel!
    @IBOutlet var apply:UILabel!
    @IBOutlet var recommend:UILabel!
    @IBOutlet var chat:UILabel!
    @IBOutlet var contact:UILabel!
    
}