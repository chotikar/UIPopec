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
        return self.contactlist.count+1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: contactCellItemId, for: indexPath) as! ContactCell
        
        var  contactDetail : ContactModel!
        print(indexPath.row)
        
        if indexPath.row != 0 {
            contactDetail = self.contactlist[indexPath.row-1]
            cell.abaclogo.isHidden = true
            cell.campusName.text = contactDetail.CampusnameEn
            print("^^")
        }else{
            cell.campusName.isHidden = true
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        if indexPath.row == 0 {
            return scHei*0.3
        }else{
            return scHei*0.6
        }
    }

//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "FacultyMajorLayout") as! FacultyMajorViewController
//        vc.facultyCode = self.faclist[indexPath.row].faculyId
//        self.navigationController?.pushViewController(vc, animated: true)
//    }

}

class ContactCell : UITableViewCell {
    
    @IBOutlet weak var abaclogo : UIImageView!
    @IBOutlet weak var campusName : UILabel!
//    @IBOutlet var latitude : UILabel!
//    @IBOutlet var longtitude : UILabel!
//    @IBOutlet var addrEn : UILabel!
//    @IBOutlet var addrTh : UILabel!
//    @IBOutlet var tel : UILabel!
//    @IBOutlet var fax : UILabel!
//    @IBOutlet var email : UILabel!
//    @IBOutlet var addrlogo1 : UIImageView!
//    @IBOutlet var addrlogo2 : UIImageView!
//    @IBOutlet var tellogo : UIImageView!
//    @IBOutlet var emaillogo : UIImageView!
    
//    override func awakeFromNib() {
//        abaclogo.frame = CGRect(x: scWid*0.35, y: 10, width: scWid*0.3, height: scWid*0.3)
//        abaclogo.layer.cornerRadius = abaclogo.frame.size.width/2
//        abaclogo.clipsToBounds = true
//        abaclogo.image = UIImage(named: "abaclogo")
//    }
//    //
//    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        // Configure the view for the selected state
//    }

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(abaclogo)
        self.contentView.addSubview(campusName)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        abaclogo.frame = CGRect(x: scWid*0.35, y: 10, width: scWid*0.3, height: scWid*0.3)
        abaclogo.layer.cornerRadius = abaclogo.frame.size.width/2
        abaclogo.image = UIImage(named: "abaclogo")
        abaclogo.clipsToBounds = true
    }
    
}

















