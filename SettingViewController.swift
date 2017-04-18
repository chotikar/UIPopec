
import UIKit
import SWRevealViewController

class SettingViewController: UIViewController {
    
    var fm = FunctionMutual.self
    @IBOutlet weak var MenuButton: UIBarButtonItem!
    
    var boxLanguage : UIView = {
       var boxl = UIView()
        boxl.frame = CGRect(x: scWid*0.05, y: scWid*0.4, width: scWid*0.5, height: scWid*0.17)
        boxl.backgroundColor = UIColor(red: 219/225, green: 218/225, blue: 216/225, alpha: 1)
        boxl.layer.cornerRadius = 10
        boxl.clipsToBounds = true
        return boxl
    }()
    var boxButton : UIView = {
        var bb = UIView()
        bb.frame = CGRect(x: scWid*0.02, y: scWid*0.02, width: scWid * 0.13, height: scWid*0.13)
        bb.layer.cornerRadius = 20
        bb.clipsToBounds = true
        return bb
    }()
    var thLanguage : UIButton = {
        var thb = UIButton()
        thb.setTitle("TH", for: .normal)
        thb.frame = CGRect(x: scWid*0.02, y: scWid*0.02, width: scWid * 0.13, height: scWid*0.13)
        thb.layer.cornerRadius = 20
        thb.clipsToBounds = true
        thb.addTarget(self, action: #selector(butLanguageAction), for: .touchUpInside)
        thb.tag = 0
        return thb
    }()
    var enLanguage  : UIButton = {
        var enb = UIButton()
        enb.setTitle("EN", for: .normal)
        enb.frame = CGRect(x: scWid*0.35, y: scWid*0.02, width: scWid * 0.13, height: scWid*0.13)
        enb.layer.cornerRadius = 20
        enb.clipsToBounds = true
        enb.tag = 1
        enb.addTarget(self, action: #selector(butLanguageAction), for: .touchUpInside)
        return enb
 
    }()
    var languageTitle : UILabel = {
       var lt = UILabel()
        lt.text = "Language Device"
        lt.textColor = UIColor.lightGray
        lt.frame = CGRect(x: scWid*0.05, y: 75, width: scWid*0.9, height: scHei*0.05)
        return lt
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        drawSettingPage(lang: CRUDSettingValue.GetUserSetting())
        Sidemenu()
        CustomNavbar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func butLanguageAction(anyobject : UIButton){
        if anyobject.tag == 0 {
            CRUDSettingValue.UpdateSetting(lang: "T")
             languageAnimate(lang:"T")
        }else{
            CRUDSettingValue.UpdateSetting(lang: "E")
             languageAnimate(lang:"E")
        }
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

    
    func drawSettingPage(lang:String){
        
        self.view.addSubview(boxLanguage)
        boxLanguage.addSubview(boxButton)
        boxLanguage.addSubview(thLanguage)
        boxLanguage.addSubview(enLanguage)
        languageAnimate(lang:CRUDSettingValue.GetUserSetting())
        
    }
    func languageAnimate(lang:String)  {
        
        if lang == "T" {
            
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn], animations: {
                self.boxButton.backgroundColor = UIColor.red
                self.thLanguage.backgroundColor = UIColor.clear
                self.thLanguage.setTitleColor(UIColor.white, for: .normal)
                self.boxButton.frame.origin.x = self.thLanguage.frame.origin.x
                self.enLanguage.backgroundColor = UIColor.white
                self.enLanguage.setTitleColor(UIColor.red, for: .normal)
                
            }, completion: nil)
        }else{
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn], animations: {
                self.boxButton.backgroundColor = UIColor.red
                self.thLanguage.backgroundColor = UIColor.white
                self.thLanguage.setTitleColor(UIColor.red, for: .normal)
                self.boxButton.frame.origin.x = self.enLanguage.frame.origin.x
                self.enLanguage.backgroundColor = UIColor.clear
                self.enLanguage.setTitleColor(UIColor.white, for: .normal)
                
                
            }, completion: nil)
            
        }

    }
    
}
