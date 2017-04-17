
import UIKit
import SWRevealViewController

class SettingViewController: UIViewController {
    
    @IBOutlet weak var MenuButton: UIBarButtonItem!
    
    var boxLanguage : UIView = {
       var boxl = UIView()
        boxl.frame = CGRect(x: scWid*0.05, y: scWid*0.3, width: scWid*0.9, height: scWid*0.2)
        boxl.backgroundColor = UIColor.lightGray
        boxl.layer.cornerRadius = 10
        boxl.clipsToBounds = true
        return boxl
    }()
    var boxButton : UIView = {
        var bb = UIView()
        bb.frame = CGRect(x: scWid*0.02, y: scWid*0.02, width: scWid * 0.18, height: scWid*0.16)
        bb.layer.cornerRadius = 20
        bb.clipsToBounds = true
        return bb
    }()
    var thLanguage : UIButton = {
        var thb = UIButton()
        thb.setTitle("TH", for: .normal)
        thb.frame = CGRect(x: scWid*0.02, y: scWid*0.02, width: scWid * 0.18, height: scWid*0.16)
        thb.layer.cornerRadius = 20
        thb.clipsToBounds = true

        thb.addTarget(self, action: #selector(butLanguageAction), for: .touchUpInside)
        thb.tag = 0
        return thb
    }()
    var enLanguage  : UIButton = {
        var enb = UIButton()
        enb.setTitle("EN", for: .normal)
        enb.frame = CGRect(x: scWid*0.71, y: scWid*0.02, width: scWid * 0.18, height: scWid*0.16)
        enb.layer.cornerRadius = 20
        enb.clipsToBounds = true
        enb.tag = 1
        enb.addTarget(self, action: #selector(butLanguageAction), for: .touchUpInside)
        return enb
 
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        drawSettingPage(lang: CRUDSettingValue.GetUserSetting())

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func butLanguageAction(anyobject : UIButton){
        if anyobject.tag == 0 {
            CRUDSettingValue.UpdateSetting(lang: "TH")
            drawSettingPage(lang:"TH")
        }else{
            CRUDSettingValue.UpdateSetting(lang: "EN")
            drawSettingPage(lang:"EN")
        }
    }
    
    func drawSettingPage(lang:String){
        
        self.view.addSubview(boxLanguage)
        boxLanguage.addSubview(boxButton)
        boxLanguage.addSubview(thLanguage)
        boxLanguage.addSubview(enLanguage)
        
        if lang == "TH" {
            
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn], animations: {
                self.boxButton.frame.origin.x = scWid*0.02
                self.boxButton.backgroundColor = UIColor.red
                self.thLanguage.backgroundColor = UIColor.clear
                self.thLanguage.setTitleColor(UIColor.white, for: .normal)
                self.enLanguage.backgroundColor = UIColor.white
                self.enLanguage.setTitleColor(UIColor.red, for: .normal)

            }, completion: nil)
        }else{
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn], animations: {
                self.boxButton.frame.origin.x = scWid*0.71
                self.boxButton.backgroundColor = UIColor.red
                self.thLanguage.backgroundColor = UIColor.white
                self.thLanguage.setTitleColor(UIColor.red, for: .normal)
                self.enLanguage.backgroundColor = UIColor.clear
                self.enLanguage.setTitleColor(UIColor.white, for: .normal)
                
            }, completion: nil)

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
        navigationController?.navigationBar.barTintColor = UIColor.clear//abacRed
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
    }

    
}
