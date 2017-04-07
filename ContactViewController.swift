

import UIKit
import SWRevealViewController

class ContactViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var navigationBarHeight = CGFloat(5.0)
    let scollView = UIScrollView()
    let headerContect = UIView()
    let ws = WebService.self
    let fm = FunctionMutual.self
    @IBOutlet var contactListTableView : UITableView!
    @IBOutlet weak var MenuButton: UIBarButtonItem!
    let abacRed = UIColor(colorLiteralRed: 255, green: 0, blue: 0, alpha: 1)
    var contactList :  [ContactModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Sidemenu()
        CustomNavbar()
        navigationBarHeight = (self.navigationController?.navigationBar.bounds.size.height)!+20
        print(navigationBarHeight)
        print(navigationBarHeight)
        scollView.frame = CGRect(x: 0, y: 64, width: scWid, height: scHei - navigationBarHeight)
        scollView.backgroundColor = UIColor.red
         self.setContactTableView(num: CGFloat(10), headerSize: self.drawHeaderIn())
//        reloadTableViewContact()
        self.view.addSubview(scollView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadTableViewContact() {
        ws.GetContactRequireWS() { (responseData : [ContactModel], nil) in DispatchQueue.main.async ( execute: {
            self.contactList = responseData
            self.contactListTableView.reloadData()
            self.setContactTableView(num: CGFloat(10), headerSize: self.drawHeaderIn())
        })
        }
    }
    
    func setContactTableView(num : CGFloat, headerSize : CGFloat){
        self.scollView.addSubview(contactListTableView)
        self.contactListTableView.backgroundColor = UIColor.white
        contactListTableView.frame = CGRect(x: 0, y: headerSize, width: scWid, height: CGFloat(num)*(scHei*0.3))
        scollView.contentSize = CGSize(width: scWid, height: (num*(scHei*0.3))+headerSize)
    }
    
    func drawHeaderIn() -> CGFloat{
        headerContect.frame = CGRect(x: 0, y: 0, width: scWid, height: scHei*0.27)
        scollView.addSubview(headerContect)
        let abaclogo = UIImageView()
        abaclogo.frame = CGRect(x: scWid*0.35, y: 10, width: scWid*0.3, height: scWid*0.3)
        abaclogo.image = UIImage(named: "abaclogo")
        let uniName = UILabel()
        uniName.frame = CGRect(x: scWid*0.05, y: scWid*0.3 + 20, width: scWid*0.9, height: scWid*0.05)
        uniName.text = "Assumption University"
        uniName.textAlignment = .center
        let line  = UIView()
        line.frame = CGRect(x: scWid*0.05, y: uniName.frame.origin.y+uniName.frame.height + 20, width: scWid*0.9, height: 1)
        line.backgroundColor = UIColor.lightGray
        headerContect.addSubview(abaclogo)
        headerContect.addSubview(uniName)
        headerContect.addSubview(line)
        return headerContect.frame.origin.y + headerContect.frame.height + 20
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCellItem", for: indexPath) as! ContactCell
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return scHei*0.25
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
        navigationController?.navigationBar.barTintColor = UIColor.clear//abacRed
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
    }
}


class ContactCell : UITableViewCell {
    let fm = FunctionMutual.self
    @IBOutlet var campusName : UILabel!
    @IBOutlet var addrEn : UITextView!
    @IBOutlet var tel : UILabel!
    @IBOutlet var fax : UILabel!
    @IBOutlet var email : UILabel!
    @IBOutlet var addrlogo1 : UIImageView!
    @IBOutlet var tellogo : UIImageView!
    @IBOutlet var emaillogo : UIImageView!
    var heir = CGFloat(0.0)
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
        campusName.font = fm.setFontSizeBold(fs: 20)
        campusName.frame = CGRect(x: scWid*0.05 , y: 10, width: scWid*0.9, height: 30)
        campusName.textColor = UIColor.darkGray
        
        heir = campusName.frame.origin.y + campusName.frame.height + 5
        addrlogo1.frame = CGRect(x: 10, y: heir+5, width: scWid*0.05, height: scWid*0.05)
        addrlogo1.image = UIImage(named: "map")
        addrEn.frame = CGRect(x: 15+scWid*0.05 , y: heir, width: scWid-(scWid*0.05+14), height: 30)
        addrEn.font = fm.setFontSizeLight(fs: 13)
        addrEn.textColor = UIColor.darkGray
        addrEn.textAlignment = .natural
        addrEn.backgroundColor = UIColor.yellow
        addrEn.isEditable = false
        
        heir = addrEn.frame.origin.y + addrEn.frame.height+10
        tellogo.frame = CGRect(x: 10, y: heir, width: scWid*0.05, height: scWid*0.05)
        tellogo.image = UIImage(named: "phone-call")
        tel.font = fm.setFontSizeLight(fs: 13)
        tel.frame = CGRect(x: 15+scWid*0.05, y: heir, width: scWid-(scWid*0.05+14), height: scWid*0.05)
        tel.textColor  = UIColor.darkGray
        
        heir = tellogo.frame.origin.y + tellogo.frame.height+10
        fax.font = fm.setFontSizeLight(fs: 13)
        fax.frame = CGRect(x: 10, y: heir, width: scWid, height: scWid*0.05)
        fax.textColor  = UIColor.darkGray
        
        heir = fax.frame.origin.y + fax.frame.height+10
        emaillogo.frame = CGRect(x: 10, y:heir, width: scWid*0.05, height: scWid*0.05)
        emaillogo.image = UIImage(named: "mail")
        email.font = fm.setFontSizeLight(fs: 13)
        email.frame = CGRect(x: 15+scWid*0.05, y: heir, width: scWid-(scWid*0.05+14), height: scWid*0.05)
        email.textColor = UIColor.darkGray
    }
    
}



