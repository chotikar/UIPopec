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
            print(self.contactlist)
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contactlist.count
    }
    
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: contactCellItemId, for: indexPath) as! ContactCell
        cell.selectionStyle = .none
        let contactdetail = self.contactlist[indexPath.row]
        cell.campusName.text = contactdetail.CampusnameEn
        cell.addrEn.text = contactdetail.AddrEn
        cell.addrTh.text = contactdetail.AddrTh
        cell.tel.text = "Tel. \(contactdetail.Telephone)"
        cell.fax.text = "Fax. \(contactdetail.Fax)"
        cell.email.text = contactdetail.Email
        cell.addrlogo1.image = UIImage(named: "map")
        cell.addrlogo2.image = UIImage(named: "map")
        cell.tellogo.image = UIImage(named: "phone-call")
        cell.emaillogo.image = UIImage(named: "mail")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return scHei*0.3
    }
}

class ContactCell : UITableViewCell {
    
//    @IBOutlet var abaclogo : UIImageView!
    @IBOutlet var campusName : UILabel!
    @IBOutlet var addrEn : UITextView!
    @IBOutlet var addrTh : UITextView!
    @IBOutlet var tel : UILabel!
    @IBOutlet var fax : UILabel!
    @IBOutlet var email : UILabel!
    @IBOutlet var addrlogo1 : UIImageView!
    @IBOutlet var addrlogo2 : UIImageView!
    @IBOutlet var tellogo : UIImageView!
    @IBOutlet var emaillogo : UIImageView!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.contentView.addSubview(abaclogo)
        self.contentView.addSubview(campusName)
        self.contentView.addSubview(addrEn)
        self.contentView.addSubview(addrTh)
        self.contentView.addSubview(tel)
        self.contentView.addSubview(fax)
        self.contentView.addSubview(email)
        self.contentView.addSubview(addrlogo1)
        self.contentView.addSubview(addrlogo2)
        self.contentView.addSubview(tellogo)
        self.contentView.addSubview(emaillogo)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        abaclogo.frame.size = CGSize(width: scWid*0.3, height: scWid*0.3)
//        abaclogo.center = CGPoint(x: scWid/2, y: scWid*0.17)
//        abaclogo.layer.cornerRadius = abaclogo.frame.size.width/2
//        abaclogo.clipsToBounds = true
        
        campusName.font = UIFont.boldSystemFont(ofSize: 20)
        campusName.frame = CGRect(x: 40, y: 10, width: scWid, height: 30)
        
//        addrEn.font = UIFont.systemFont(ofSize: 12)
//        addrEn.frame = CGRect(x: 40, y: 40, width: scWid - 10, height: 50)
//        addrEn.textColor = UIColor.darkGray
        
    
//        
//        addrTh.font = UIFont.systemFont(ofSize: 12)
//        //addrTh.frame = CGRect(x: 40, y: 60, width: scWid-10, height: 50)
//        addrTh.textColor = UIColor.darkGray
        
        tel.font = UIFont.systemFont(ofSize: 12)
        tel.frame = CGRect(x: 40, y: 80, width: scWid, height: 30)
        tel.textColor  = UIColor.darkGray
        
        fax.font = UIFont.systemFont(ofSize: 12)
        fax.frame = CGRect(x: 140, y: 80, width: scWid, height: 30)
        fax.textColor  = UIColor.darkGray
        
        email.font = UIFont.systemFont(ofSize: 12)
        email.frame = CGRect(x: 40, y: 100, width: scWid, height: 30)
        email.textColor = UIColor.darkGray
        
        addrlogo1.frame = CGRect(x: 10, y: 45, width: scWid*0.05, height: scWid*0.05)
        addrlogo2.frame = CGRect(x: 10, y: 65, width: scWid*0.05, height: scWid*0.05)
        tellogo.frame = CGRect(x: 10, y: 85, width: scWid*0.05, height: scWid*0.05)
        emaillogo.frame = CGRect(x: 10, y: 105, width: scWid*0.05, height: scWid*0.05)
    }
    

    
    
    
    
}
