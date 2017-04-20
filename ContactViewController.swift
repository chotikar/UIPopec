
import UIKit
import SWRevealViewController

class ContactViewController: UIViewController {
    
    @IBOutlet weak var MenuButton: UIBarButtonItem!
    let ws = WebService.self
    let fm = FunctionMutual.self
    
    var headerContect : UIView = {
        var hc = UIView()
        hc.frame = CGRect(x: 0, y: 0, width: scWid, height: scHei*0.27)
        return hc
    }()
    
    var scrollView : UIScrollView = {
        var sv = UIScrollView()
        sv.frame = CGRect(x: 0, y: 0, width: scWid, height: scHei)
        return sv
    }()
    
    var contactList :  [ContactModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawHeaderIn()
        Sidemenu()
        CustomNavbar()
        reloadTableViewContact(language: CRUDSettingValue.GetUserSetting())
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadTableViewContact(language:String) {
        ws.GetContactRequireWS(lang: language) { (responseData : [ContactModel], nil) in DispatchQueue.main.async ( execute: {
            self.contactList = responseData
            self.scrollView.contentSize = CGSize(width:scWid,height:self.drawList(contactList: self.contactList))
        })
        }
    }
    
    func drawHeaderIn() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(headerContect)
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
    }
    
    func drawList(contactList:[ContactModel]) -> CGFloat{
        var hei = CGFloat(scHei*0.27)
        var boxSize = CGRect()
        for con in contactList {
            boxSize = fm.calculateHeiFromString(text: con.Campusname, fontsize: fm.setFontSizeBold(fs: 19), tbWid: scWid)
            var campusName = UILabel()
            campusName = UILabel(frame: CGRect(x: scWid*0.05, y: hei, width: scWid*0.9, height: boxSize.height))
            campusName.font = fm.setFontSizeBold(fs: 20)
            campusName.textColor = UIColor.darkGray
            campusName.text = con.Campusname
            hei = hei + boxSize.height
            
            boxSize = fm.calculateHeiFromString(text: con.Addr, fontsize: fm.setFontSizeLight(fs: 13.5), tbWid: scWid)
            //            var addrlogo = UIImageView()
            //            addrlogo = UIImageView(frame: CGRect(x: scWid*0.05, y: hei+5
            //                , width: scWid*0.05, height: scWid*0.05))
            //            addrlogo.image = UIImage(named: "map")
            
            var address = UITextView()
            address = UITextView(frame: CGRect(x: scWid*0.05 , y: hei, width: scWid*0.9, height:boxSize.height))
            address.isEditable = false
            address.font = fm.setFontSizeLight(fs: 13)
            address.textColor = UIColor.darkGray
            address.text = con.Addr
            address.textAlignment = .left
            hei = hei + boxSize.height
            
            boxSize = fm.calculateHeiFromString(text: con.Telephone, fontsize: fm.setFontSizeLight(fs: 13), tbWid: scWid)
            var tellogo = UIImageView()
            tellogo = UIImageView(frame: CGRect(x: scWid*0.05, y: hei, width: scWid*0.05, height: scWid*0.05))
            tellogo.image = UIImage(named: "phone-call")
            var tel = UILabel()
            tel = UILabel(frame: CGRect(x: 14+scWid*0.1, y: hei-5, width: scWid-(scWid*0.1+14), height: scWid*0.1))
            tel.font = fm.setFontSizeLight(fs: 13)
            tel.text = con.Telephone
            tel.textColor = UIColor.darkGray
            hei = hei + boxSize.height+10
            
            boxSize = fm.calculateHeiFromString(text: con.Fax, fontsize: fm.setFontSizeLight(fs: 13), tbWid: scWid)
            var fax = UILabel()
            fax = UILabel(frame: CGRect(x: scWid*0.05, y: hei, width: scWid-(scWid*0.1), height: boxSize.height))
            fax.font = fm.setFontSizeLight(fs: 13)
            fax.text = "Fax.  \(con.Fax)"
            fax.textColor  = UIColor.darkGray
            hei = hei + boxSize.height+10
            
            boxSize = fm.calculateHeiFromString(text: con.Email, fontsize: fm.setFontSizeLight(fs: 13), tbWid: scWid)
            var emaillogo = UIImageView()
            emaillogo = UIImageView(frame: CGRect(x: scWid*0.05, y: hei, width: scWid*0.05, height: scWid*0.05))
            emaillogo.image = UIImage(named: "mail")
            var email = UILabel()
            email = UILabel(frame: CGRect(x: 14+scWid*0.1, y: hei, width: scWid-(scWid*0.1+14), height: boxSize.height))
            email.font = fm.setFontSizeLight(fs: 13)
            email.text = con.Email
            email.textColor  = UIColor.darkGray
            hei = hei + boxSize.height+10
            
            var line = UIView()
            line =  UIView(frame: CGRect(x: scWid*0.1, y: hei, width: scWid*0.8, height: 1))
            line.backgroundColor = UIColor.lightGray
            hei = hei + 21
            
            self.scrollView.addSubview(campusName)
            self.scrollView.addSubview(address)
            //            self.scrollView.addSubview(addrlogo)
            self.scrollView.addSubview(tellogo)
            self.scrollView.addSubview(tel)
            self.scrollView.addSubview(fax)
            self.scrollView.addSubview(emaillogo)
            self.scrollView.addSubview(email)
            self.scrollView.addSubview(line)
            
        }
        return hei
    }
    
    func CustomNavbar() {
        navigationController?.navigationBar.barTintColor = abacRed
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
    }
    func Sidemenu() {
        if revealViewController() != nil {
            MenuButton.target = SWRevealViewController()
            MenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    
}

//
//
//import UIKit
//import SWRevealViewController
//
//class ContactViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//
//    var navigationBarHeight = CGFloat(5.0)
//    let scollView = UIScrollView()
//    let headerContect = UIView()
//    let ws = WebService.self
//    let fm = FunctionMutual.self
//    @IBOutlet var contactListTableView : UITableView!
//    @IBOutlet weak var MenuButton: UIBarButtonItem!
//    let abacRed = UIColor(colorLiteralRed: 255, green: 0, blue: 0, alpha: 1)
//    var contactList :  [ContactModel] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        Sidemenu()
//        CustomNavbar()
//        navigationBarHeight = (self.navigationController?.navigationBar.bounds.size.height)!+20
//        print(navigationBarHeight)
//        print(navigationBarHeight)
//        scollView.frame = CGRect(x: 0, y: 0, width: scWid, height: scHei)
//         self.setContactTableView(num: CGFloat(10), headerSize: self.drawHeaderIn())
//        reloadTableViewContact(language: CRUDSettingValue.GetUserSetting())
//        self.view.addSubview(scollView)
//
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    func reloadTableViewContact(language:String) {
//        ws.GetContactRequireWS(lang: language) { (responseData : [ContactModel], nil) in DispatchQueue.main.async ( execute: {
//            self.contactList = responseData
//            self.contactListTableView.reloadData()
//            self.setContactTableView(num: CGFloat(self.contactList.count), headerSize: self.drawHeaderIn())
//        })
//        }
//    }
//
//    func setContactTableView(num : CGFloat, headerSize : CGFloat){
//        self.scollView.addSubview(contactListTableView)
//        self.contactListTableView.backgroundColor = UIColor.white
//        contactListTableView.frame = CGRect(x: 0, y: headerSize, width: scWid, height: CGFloat(num)*(scHei*0.3))
//        scollView.contentSize = CGSize(width: scWid, height: (num*(scHei*0.3))+headerSize)
//    }
//
//    func drawHeaderIn() -> CGFloat{
//        headerContect.frame = CGRect(x: 0, y: 0, width: scWid, height: scHei*0.27)
//        scollView.addSubview(headerContect)
//        let abaclogo = UIImageView()
//        abaclogo.frame = CGRect(x: scWid*0.35, y: 10, width: scWid*0.3, height: scWid*0.3)
//        abaclogo.image = UIImage(named: "abaclogo")
//        let uniName = UILabel()
//        uniName.frame = CGRect(x: scWid*0.05, y: scWid*0.3 + 20, width: scWid*0.9, height: scWid*0.05)
//        uniName.text = "Assumption University"
//        uniName.textAlignment = .center
//        let line  = UIView()
//        line.frame = CGRect(x: scWid*0.05, y: uniName.frame.origin.y+uniName.frame.height + 20, width: scWid*0.9, height: 1)
//        line.backgroundColor = UIColor.lightGray
//        headerContect.addSubview(abaclogo)
//        headerContect.addSubview(uniName)
//        headerContect.addSubview(line)
//        return headerContect.frame.origin.y + headerContect.frame.height + 20
//    }
//
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.contactList.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCellItem", for: indexPath) as! ContactCell
//        let contact = self.contactList[indexPath.row]
//            cell.addHei = fm.calculateHeiFromString(text: contact.Addr, fontsize: fm.setFontSizeLight(fs: 12.5), tbWid: 200).height
//        cell.addrEn.text = contact.Addr
//        cell.campusName.text = contact.Campusname
//        cell.email.text = contact.Email
//        cell.fax.text = "Fax.  \(contact.Fax)"
//        cell.tel.text = contact.Telephone
//        return cell
//
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let contact = self.contactList[indexPath.row]
//        let conHei = fm.calculateHeiFromString(text: contact.Addr, fontsize: fm.setFontSizeLight(fs: 12.5), tbWid: 200).height + 20
//        print("Heic : \(113.5 + conHei)")
//        return (113.5 + conHei)
//    }
//
//    func Sidemenu() {
//        if revealViewController() != nil {
//            MenuButton.target = SWRevealViewController()
//            MenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
//            revealViewController().rearViewRevealWidth = 275
//            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//        }
//    }
//
//    func CustomNavbar() {
//        navigationController?.navigationBar.barTintColor = abacRed
//        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
//
//    }
//}
//
//
//class ContactCell : UITableViewCell {
//    let fm = FunctionMutual.self
//    @IBOutlet var campusName : UILabel!
//    @IBOutlet var addrEn : UITextField!
//    @IBOutlet var tel : UILabel!
//    @IBOutlet var fax : UILabel!
//    @IBOutlet var email : UILabel!
//    @IBOutlet var addrlogo1 : UIImageView!
//    @IBOutlet var tellogo : UIImageView!
//    @IBOutlet var emaillogo : UIImageView!
//    var addHei : CGFloat!
//    var heir = CGFloat(0.0)
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.contentView.addSubview(campusName)
//        self.contentView.addSubview(addrEn)
//        self.contentView.addSubview(tel)
//        self.contentView.addSubview(fax)
//        self.contentView.addSubview(email)
//        self.contentView.addSubview(addrlogo1)
//        self.contentView.addSubview(tellogo)
//        self.contentView.addSubview(emaillogo)
//        self.contentView.addSubview(addrEn)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        campusName.font = fm.setFontSizeBold(fs: 20)
//        campusName.frame = CGRect(x: scWid*0.05 , y: 10, width: scWid*0.9, height: 30)
//        campusName.textColor = UIColor.darkGray
//
//        heir = campusName.frame.origin.y + campusName.frame.height + 5
//        addrlogo1.frame = CGRect(x: 10, y: heir+5, width: scWid*0.05, height: scWid*0.05)
//        addrlogo1.image = UIImage(named: "map")
//        addrEn.frame = CGRect(x: 15+scWid*0.05 , y: heir, width: scWid-(scWid*0.05+14), height: addHei)
//        addrEn.font = fm.setFontSizeLight(fs: 13)
//        addrEn.textColor = UIColor.darkGray
//        addrEn.backgroundColor = UIColor.yellow
//        addrEn.textAlignment = .natural
////        addrEn.isScrollEnabled = false
////        addrEn.isEditable = false
//
//        heir = addrEn.frame.origin.y + addrEn.frame.height
//        tellogo.frame = CGRect(x: 10, y: heir, width: scWid*0.05, height: scWid*0.05)
//        tellogo.image = UIImage(named: "phone-call")
//        tel.font = fm.setFontSizeLight(fs: 13)
//        tel.frame = CGRect(x: 15+scWid*0.05, y: heir, width: scWid-(scWid*0.05+14)-5, height: scWid*0.05)
//        tel.textColor  = UIColor.darkGray
//
//        heir = tellogo.frame.origin.y + tellogo.frame.height+5
//        fax.font = fm.setFontSizeLight(fs: 13)
//        fax.frame = CGRect(x: 10, y: heir, width: scWid, height: scWid*0.05)
//        fax.textColor  = UIColor.darkGray
//
//        heir = fax.frame.origin.y + fax.frame.height+5
//        emaillogo.frame = CGRect(x: 10, y:heir, width: scWid*0.05, height: scWid*0.05)
//        emaillogo.image = UIImage(named: "mail")
//        email.font = fm.setFontSizeLight(fs: 13)
//        email.frame = CGRect(x: 15+scWid*0.05, y: heir, width: scWid-(scWid*0.05+14), height: scWid*0.05)
//        email.textColor = UIColor.darkGray
//
//        let line  = UIView()
//        line.frame = CGRect(x: scWid*0.05, y: email.frame.origin.y+email.frame.height + 10, width: scWid*0.9, height: 0.5)
//        line.backgroundColor = UIColor.lightGray
//
//        print(line.frame.height + line.frame.origin.y)
//
//    }
//
//}
//
//
//
