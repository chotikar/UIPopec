//
//  ContactViewController.swift
//  UIPSOPEC
//
//  Created by Popp on 3/25/17.
//  Copyright © 2017 Senior Project. All rights reserved.
//

import UIKit
import SWRevealViewController

class ContactTableViewController : UITableViewController {
    
    @IBOutlet weak var MenuButton: UIBarButtonItem!
    
    var contactlist : [ContactModel] = []
    let contactCellItemId = "ContactCellItem"
    let ws = WebService.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Sidemenu()
        CustomNavbar()
        reloadTableview()
        
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
    
    func reloadTableview() {
        ws.GetContactRequireWS() { (responseData : [ContactModel], nil) in DispatchQueue.main.async ( execute: {
            self.contactlist = responseData
            self.tableView.reloadData()
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.contactlist.count
    }
    
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCellItem", for: indexPath) as! ContactCell
//let header = tableView.dequeueReusableCell(withIdentifier: "ContactHeaderCellItem", for: indexPath) as! ContactHeaderCell
        
        var  contactdetail : ContactModel!
//        print(indexPath.row)
//        if indexPath.row == 0 {
////            header.selectionStyle = .none
//           return header
//        }else{
            contactdetail = self.contactlist[indexPath.row]
            print(contactdetail.CampusnameEn)
                    cell.campusName.text = contactdetail.CampusnameEn
        cell.addrEn.text = contactdetail.AddrEn
        cell.tel.text = "Tel. \(contactdetail.Telephone)"
        cell.fax.text = "Fax. \(contactdetail.Fax)"
        cell.email.text = contactdetail.Email
        cell.addrlogo1.image = UIImage(named: "map")
        cell.tellogo.image = UIImage(named: "phone-call")
        cell.emaillogo.image = UIImage(named: "mail")
        return cell

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
//        if indexPath.row == 0 {
//            return scHei*0.25
//        }else{
            return scHei*0.2
//        }

    }
}

class ContactCell : UITableViewCell {
    @IBOutlet var campusName : UILabel!
    @IBOutlet var addrEn : UITextView!
    @IBOutlet var tel : UILabel!
    @IBOutlet var fax : UILabel!
    @IBOutlet var email : UILabel!
    @IBOutlet var addrlogo1 : UIImageView!
    @IBOutlet var tellogo : UIImageView!
    @IBOutlet var emaillogo : UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(campusName)
        self.contentView.addSubview(addrEn)
        self.contentView.addSubview(tel)
        self.contentView.addSubview(fax)
        self.contentView.addSubview(email)
        self.contentView.addSubview(addrlogo1)
        self.contentView.addSubview(tellogo)
        self.contentView.addSubview(emaillogo)
        self.contentView.addSubview(addrEn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        campusName.font = UIFont(name:"Roboto-Bold", size: 20)
        campusName.frame = CGRect(x: 40, y: 10, width: scWid, height: 30)
        campusName.textColor = UIColor.darkGray
        
        addrEn.frame = CGRect(x: 35, y: 35, width: scWid  * 0.88, height: self.addrEn.contentSize.height)
        addrEn.font = UIFont(name: "Roboto-Light", size: 12)
        addrEn.textColor = UIColor.darkGray
        addrEn.isEditable = false
        
        tel.font = UIFont(name: "Roboto-Light", size: 12)
        tel.frame = CGRect(x: 40, y: 70, width: scWid, height: 30)
        tel.textColor  = UIColor.darkGray
        
        fax.font = UIFont(name: "Roboto-Light", size: 12)
        fax.frame = CGRect(x: 140, y: 70, width: scWid, height: 30)
        fax.textColor  = UIColor.darkGray
        
        email.font = UIFont(name: "Roboto-Light", size: 12)
        email.frame = CGRect(x: 40, y: 90, width: scWid, height: 30)
        email.textColor = UIColor.darkGray

        addrlogo1.frame = CGRect(x: 10, y: 48, width: scWid*0.05, height: scWid*0.05)

        tellogo.frame = CGRect(x: 10, y: 75, width: scWid*0.05, height: scWid*0.05)
        emaillogo.frame = CGRect(x: 10, y:95, width: scWid*0.05, height: scWid*0.05)
    }
    
}


class ContactHeaderCell : UITableViewCell {
    
    @IBOutlet var abaclogo : UIImageView!
    @IBOutlet var uniName : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(abaclogo)
        self.contentView.addSubview(uniName)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        abaclogo.frame = CGRect(x: scWid*0.35, y: 10, width: scWid*0.3, height: scWid*0.3)
        abaclogo.image = UIImage(named: "abaclogo")
        
        uniName.frame = CGRect(x: scWid*0.05, y: scWid*0.3 + 20, width: scWid*0.9, height: scWid*0.05)
        uniName.text = "Assumption University"
        uniName.textAlignment = .center
    }
    
}















