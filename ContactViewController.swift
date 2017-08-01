
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
    var activityiIndicator : UIActivityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        drawHeaderIn()
        Sidemenu()
        CustomNavbar()
        startIndicator()
        reloadTableViewContact(language: CRUDSettingValue.GetUserSetting())
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startIndicator(){
        self.activityiIndicator.center = self.view.center
        self.activityiIndicator.hidesWhenStopped = true
        self.activityiIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityiIndicator)
        activityiIndicator.startAnimating()
    }
    
    func stopIndicator(){
        self.activityiIndicator.stopAnimating()
    }

    
    func reloadTableViewContact(language:String) {
        ws.GetContactRequireWS(lang: language) { (responseData : [ContactModel], nil) in DispatchQueue.main.async ( execute: {
            self.contactList = responseData
            self.scrollView.contentSize = CGSize(width:scWid,height:self.drawList(contactList: self.contactList))
            self.stopIndicator()
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
            boxSize = fm.calculateHeiFromString(text: con.Campusname, fontsize: 19, tbWid: scWid)
            var campusName = UILabel()
            campusName = UILabel(frame: CGRect(x: scWid*0.05, y: hei, width: scWid*0.9, height: boxSize.height))
            campusName.font = fm.setFontSizeBold(fs: 19)
            campusName.textColor = UIColor.darkGray
            campusName.text = con.Campusname
            hei = hei + boxSize.height
            
            boxSize = fm.calculateHeiFromString(text: con.Addr, fontsize: 13.5, tbWid: scWid)
            //            var addrlogo = UIImageView()
            //            addrlogo = UIImageView(frame: CGRect(x: scWid*0.05, y: hei+5
            //                , width: scWid*0.05, height: scWid*0.05))
            //            addrlogo.image = UIImage(named: "map")
            
            var address = UITextView()
            address = UITextView(frame: CGRect(x: scWid*0.05 , y: hei, width: scWid*0.9, height:boxSize.height + 10))
            address.isEditable = false
            address.font = fm.setFontSizeLight(fs: 13)
            address.textColor = UIColor.darkGray
            address.text = con.Addr
            address.isUserInteractionEnabled = false
            address.textAlignment = .left
            hei = hei + boxSize.height
            
            boxSize = fm.calculateHeiFromString(text: con.Telephone, fontsize: 13, tbWid: scWid)
            var tellogo = UIImageView()
            tellogo = UIImageView(frame: CGRect(x: scWid*0.05, y: hei, width: scWid*0.05, height: scWid*0.05))
            tellogo.image = UIImage(named: "phone-call")
            var tel = UILabel()
            tel = UILabel(frame: CGRect(x: 14+scWid*0.1, y: hei - 6, width: scWid-(scWid*0.1+14), height: scWid*0.1))
            tel.font = fm.setFontSizeLight(fs: 13)
            tel.text = con.Telephone
            tel.textColor = UIColor.darkGray
            hei = hei + boxSize.height+10
            
            boxSize = fm.calculateHeiFromString(text: con.Fax, fontsize: 13, tbWid: scWid)
            var fax = UILabel()
            fax = UILabel(frame: CGRect(x: scWid*0.05, y: hei, width: scWid-(scWid*0.1), height: boxSize.height))
            fax.font = fm.setFontSizeLight(fs: 13)
            fax.text = "Fax.  \(con.Fax)"
            fax.textColor  = UIColor.darkGray
            hei = hei + boxSize.height+10
            
            boxSize = fm.calculateHeiFromString(text: con.Email, fontsize: 13, tbWid: scWid)
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
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    func Sidemenu() {
      
            MenuButton.target = SWRevealViewController()
            MenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
         
    }
    
    
}
