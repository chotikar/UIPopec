

import Foundation
import UIKit
import SWRevealViewController

class SuggestionTableViewController : UIViewController,UITableViewDelegate,UITableViewDataSource  {
    
    @IBOutlet weak var FacSuggestTableView: UITableView!
    @IBOutlet weak var SuggestTableView:UITableView!
    @IBOutlet weak var MenuButton: UIBarButtonItem!
    var facSugWs = [FacSuggestionModel]()
    var keywordWs = [KeyWordModel]()
    let  filterview = UIView()
    let ws = WebService.self

//    var suggestProgram :[]()
    let facSuggestId = "facSugCellID"
    let suggestId = "sugCellID"
    var titleButton = UIButton()
    var doneBut = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = titleButton
        titleButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        drawSuggestionFac()
        setTableview()
        Sidemenu()
        CustomNavbar()
         loadFacultyWS(sc:"0",lang:CRUDSettingValue.GetUserSetting())
         loadKeywordWS(lang:CRUDSettingValue.GetUserSetting())
        

    }

    func setTableview(){
        SuggestTableView.delegate = self
        SuggestTableView.dataSource = self
        SuggestTableView.register(UITableViewCell.self, forCellReuseIdentifier: suggestId)

        FacSuggestTableView.delegate = self
        FacSuggestTableView.dataSource = self
        FacSuggestTableView.register(UITableViewCell.self, forCellReuseIdentifier: facSuggestId)
}

    func drawSuggestionFac(){
        self.view.addSubview(FacSuggestTableView)
        self.filterview.addSubview(SuggestTableView)
        self.filterview.addSubview(doneBut)
        titleButton.setTitle("Suggestion", for: .normal)
        doneBut.setTitle("Done", for: .normal)
        doneBut.layer.cornerRadius = 20
        doneBut.clipsToBounds = true
//        doneBut.layer.borderColor = UIColor.white as! CGColor 
        SuggestTableView.backgroundColor = UIColor.red
        SuggestTableView.frame = CGRect(x: 0, y: 0, width: scWid*0.8, height: scHei*0.7)
        doneBut.frame = CGRect(x: scWid*0.3, y: scHei*0.725, width: scWid*0.2, height: scHei*0.05 )
        doneBut.addTarget(self, action: #selector(getChoose), for: .touchUpInside)
        SuggestTableView.backgroundColor = UIColor.white
        FacSuggestTableView.frame = CGRect(x: 0, y: 0, width: scWid, height: scHei)
    }
    
    func loadFacultyWS(sc:String,lang:String){
        ws.GetSuggestionFacRequireWS(sugCode: sc, lang: lang){ (responseData: [FacSuggestionModel], nil) in
            DispatchQueue.main.async( execute: {
                self.facSugWs = responseData
                self.FacSuggestTableView.reloadData()
            })
        }
    }
    
    func loadKeywordWS(lang:String){
        ws.GetKeyWordRequireWS(lang: lang){ (responseData: [KeyWordModel], nil) in
            DispatchQueue.main.async( execute: {
                self.keywordWs = responseData
                self.SuggestTableView.reloadData()
            })
        }

    }
   
    func getChoose(sender : AnyObject){
        var code = ""
        for i in self.keywordWs {
            if i.choose{
                code = code + String(i.keywordID) + ";"
            }
        }
        loadFacultyWS(sc: "\(code)0", lang: CRUDSettingValue.GetUserSetting())
         buttonPressed(sender: UIButton())
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.SuggestTableView {
            return self.keywordWs.count
        }else{
            return self.facSugWs.count
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      var cell = UITableViewCell()
        cell.selectionStyle = .none
        if tableView == self.FacSuggestTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: facSuggestId, for: indexPath)
            let fac = self.facSugWs[indexPath.row]
            cell.textLabel?.text = fac.programName
            cell.detailTextLabel?.text = fac.facultyName
            cell.imageView?.image = UIImage(named: "User_Shield")
            // cell.imageView?.loadImageUsingCacheWithUrlString(urlStr: "http://static1.squarespace.com/static/525f350ee4b0fd74e5ba0495/t/53314e2be4b00782251d9427/1481141044684/?format=1500w")
            cell.imageView?.contentMode = .scaleAspectFill
        }
        
        if tableView == self.SuggestTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: suggestId, for: indexPath)
            let key = self.keywordWs[indexPath.row]
            cell.textLabel?.text = key.keyword
            cell.imageView?.image = UIImage(named:key.chooseImg)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.SuggestTableView {
            editChoose(i: indexPath.row)
        }
        
        if tableView == self.FacSuggestTableView{
            let programe = self.facSugWs[indexPath.row]
            let vc = storyboard?.instantiateViewController(withIdentifier: "MajorLayout") as! MajorViewController
            vc.facultyFullName = programe.facultyName
            vc.facCode = programe.facultyID
            vc.majorCode = programe.programID
            self.navigationController?.pushViewController(vc, animated: true)
            //            let facController = MajorViewController()
//            facController.facCode = programe.facultyID
//            facController.majorCode = programe.programID
//            facController.facultyFullName = programe.facultyName
//            navigationController?.pushViewController(facController, animated: true)
        }
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if tableView == self.SuggestTableView {
               return scHei*0.07
            }else{
                return scHei*0.13
        }
    }
    
    func editChoose(i: Int){
        
        if self.keywordWs[i].choose {
            self.keywordWs[i].choose = false
            self.keywordWs[i].chooseImg = "not choose"
        }else{
            self.keywordWs[i].choose = true
            self.keywordWs[i].chooseImg = "choose"
            
        }
        self.SuggestTableView.reloadData()
      
    }
 
    
    func buttonPressed(sender: AnyObject) {
        filterview.frame  = CGRect(x: scWid*0.1, y: 70, width: scWid * 0.8, height: scHei * 0.8)
        filterview.backgroundColor = UIColor.lightGray
        filterview.layer.borderWidth = 1
        filterview.layer.borderColor = UIColor.white.cgColor
        filterview.layer.cornerRadius = 5
        self.view.addSubview(filterview)
        
        
        filterview.isHidden = !filterview.isHidden
        
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

}

class SuggestCell : UITableViewCell {
    
    @IBOutlet var checkBut : UIButton!
    @IBOutlet var keyword : UILabel!
    let fm = FunctionMutual.self
    var choose = false
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(checkBut)
        self.contentView.addSubview(keyword)
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        checkBut.frame = CGRect(x: scWid*0.05, y: scWid*0.01, width: scWid*0.08, height: scWid*0.08)
        checkBut.addTarget(self, action: #selector(checkAction), for: .touchUpInside)
        keyword.frame = CGRect(x: scWid*0.13, y: scWid*0.01, width: 0.23, height: scWid*0.08)    }

    
    func checkAction(ui :AnyObject){
        if choose {
            checkBut.setImage(UIImage(named:"choose"), for: .normal)
        }else{
            checkBut.setImage(UIImage(named:"not choose"), for: .normal)

        }
    }
    
}

