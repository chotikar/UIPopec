//
//  ViewController.swift
//  UIPSOPEC
//
//  Created by Chotikar on 2/13/2560 BE.
//  Copyright © 2560 Senior Project. All rights reserved.
//

import UIKit
import SwiftR


class ViewController: UIViewController {

    
    let scWid = UIScreen.main.bounds.width
    let scHei = UIScreen.main.bounds.height
    var headerSize = CGFloat(0)
    var chatContainer : UIView!
    var textRespond : UITextField! = nil
    var sentRespond :UIButton! = nil
    var hub :Hub!
    var connection : SignalR!
    
    var lastborder = CGFloat(0)
    
    let ws = WebService()
    override func viewDidLoad() {
        super.viewDidLoad()
        getFacultyWS()
//        
//        headerSize = CGFloat((self.navigationController?.navigationBar.frame.size.height)!+(UIApplication.shared.statusBarFrame.height))
//        lastborder = headerSize
//        chatContainer = UIView(frame: CGRect(x: 0, y: headerSize, width: scWid, height: scHei-headerSize-(scHei*0.1)))
//        chatContainer.backgroundColor = UIColor(patternImage: UIImage(named: "ChatBackground" )!)
//        self.view.addSubview(chatContainer)
//        drawChatLayout()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var facultyFilter : [FacultyModel] = []
    var facultyList : [FacultyModel] = []
    
    private func filterFacultyBy(searchInput: String){
        facultyFilter = facultyList.filter({
            (fac: FacultyModel) -> Bool in
            return fac.facultyName.lowercased().contains(searchInput.lowercased()) || fac.facultyAbb.lowercased().contains(searchInput.lowercased())||searchInput == ""
        })
    }
    
    let domainName = "http://tskyonline.com:89/"
    func getFacultyWS() {
        let requestURL: NSURL = NSURL(string: domainName + "Faculty/getFacultyList")!
        let request = URLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            if error == nil {
                let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                if let validJson = json as? [[String:AnyObject]] {
                    for i in validJson {
                        self.facultyList.append(FacultyModel(dic: i as AnyObject))
                        
                    }
                }
                self.filterFacultyBy(searchInput: "")
                print("*************\(self.facultyList)")
            }
        }
        task.resume()
    }

    
    
//    func drawChatLayout() {
//    
//        //Respond Box
//        let respondContainer : UIView = UIView(frame: CGRect(x: 0, y: scHei*0.9, width: scWid, height: scHei*0.1))
//        respondContainer.backgroundColor = UIColor.brown
//        self.view.addSubview(respondContainer)
//        let textRespondBg : UIView = UIView(frame: CGRect(x: scWid*0.02, y: scHei*0.91, width: scWid*0.76, height: scHei*0.08))
//        textRespondBg.layer.cornerRadius = 5
//        textRespondBg.backgroundColor = UIColor.white
//        self.view.addSubview(textRespondBg)
//        let textRespondBg2 : UITextField = UITextField(frame: CGRect(x: scWid*0.0295, y: scHei*0.917, width: scWid*0.74, height: scHei*0.067))
//        textRespondBg2.layer.cornerRadius = 5
//        textRespondBg2.layer.borderWidth = 1
//        textRespondBg2.layer.borderColor = UIColor.lightGray.cgColor
//        textRespondBg2.backgroundColor = UIColor.white
//        self.view.addSubview(textRespondBg2)
//        textRespond = UITextField(frame: CGRect(x: scWid*0.05, y: scHei*0.922, width: scWid*0.695, height: scHei*0.057))
//        textRespond.layer.cornerRadius = 4
//        textRespond.placeholder = "Type Text"
//        textRespond.textAlignment = .left
//        textRespond.backgroundColor = UIColor.white
//        textRespond.textColor = UIColor.gray
//        self.view.addSubview(textRespond)
//        let sentRespondBg :UIView = UIView(frame: CGRect(x: scWid*0.8, y: scHei*0.915, width: scWid*0.18, height: scHei*0.07))
//        sentRespondBg.layer.cornerRadius = 5
//        sentRespondBg.backgroundColor = UIColor.white
//        sentRespondBg.alpha = 0.5
//        self.view.addSubview(sentRespondBg)
//        sentRespond = UIButton(frame: CGRect(x: scWid*0.8, y: scHei*0.91, width: scWid*0.18, height: scHei*0.08))
//        sentRespond.layer.cornerRadius = 5
//        sentRespond.setTitle(" SENT ", for: .normal)
//        self.view.addSubview(sentRespond)
//        
//    }

}

