

import Foundation
import UIKit
import SWRevealViewController

class SuggestionTableViewController : UIViewController,UITableViewDelegate,UITableViewDataSource  {
    
    @IBOutlet weak var FacSuggestTableView: UITableView!
    @IBOutlet weak var SuggestTableView:UITableView!
    @IBOutlet weak var MenuButton: UIBarButtonItem!
    var word = [String]()
    var result: UIView!
    var resultword: UILabel!
    var facSugWs = [FacSuggestionModel]()
    var keywordWs = [KeyWordModel]()
    let filterview = UIView()
    let ws = WebService.self
    let fm = FunctionMutual.self
    let facSuggestId = "facSugCellID"
    let suggestId = "sugCellID"
    var count:Int = 0
    var titleButton = UIButton()
    var doneBut = UIButton()
    var navWid : CGFloat!
    var navIcon = UIImageView()
    var activityiIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    var calHei:CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navWid = self.navigationItem.titleView?.frame.width
        titleButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        drawSuggestionFac()
        setTableview()
        Sidemenu()
        CustomNavbar()
        stopIndicator()
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
        result = UIView(frame: CGRect(x: 0, y: 64, width: scWid, height: 20))
        self.view.addSubview(FacSuggestTableView)
        self.filterview.addSubview(SuggestTableView)
        self.filterview.addSubview(doneBut)
        self.view.addSubview(result)
        
        doneBut.setTitle("Done", for: .normal)
        doneBut.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        doneBut.layer.cornerRadius = 5
        doneBut.clipsToBounds = true
        doneBut.frame = CGRect(x: filterview.frame.width / 2, y: scHei*0.85, width: scWid*0.5, height: scHei*0.05 )
        doneBut.center = CGPoint(x: scWid / 2, y: scHei * 0.85)
        doneBut.backgroundColor = abacRed
        doneBut.addTarget(self, action: #selector(getChoose), for: .touchUpInside)
        
        FacSuggestTableView.frame = CGRect(x: 0, y: 0, width: scWid, height: scHei)
        
        SuggestTableView.backgroundColor = UIColor.white
        SuggestTableView.frame = CGRect(x: 30, y: 10, width: scWid - 30, height: scHei * 0.81)
        SuggestTableView.separatorStyle = .none
        
    }
    
    func loadFacultyWS(sc:String,lang:String){
        ws.GetSuggestionFacRequireWS(sugCode: sc, lang: lang){ (responseData: [FacSuggestionModel], nil) in
            DispatchQueue.main.async( execute: {
                self.facSugWs = responseData
                self.FacSuggestTableView.reloadData()
                self.stopIndicator()
            })
        }
    }
    
    func loadKeywordWS(lang:String){
        ws.GetKeyWordRequireWS(lang: lang){ (responseData: [KeyWordModel], nil) in
            DispatchQueue.main.async( execute: {
                self.keywordWs = responseData
                self.SuggestTableView.reloadData()
                self.stopIndicator()
            })
        }
        
    }
    
    func getChoose(sender : AnyObject){
        var code = ""
        for i in self.keywordWs {
            if i.choose{
                code = code + String(i.keywordID) + ";"
                word.append(String(i.keyword))
            }
        }
        self.startIndicator()
        loadFacultyWS(sc: "\(code)0", lang: CRUDSettingValue.GetUserSetting())
        
        if word.isEmpty {
            result.isHidden = true
            FacSuggestTableView.frame = CGRect(x: 0, y: 0, width: scWid, height: scHei)

        }else {
            FacSuggestTableView.frame = CGRect(x: 0, y: result.frame.height + 5, width: scWid, height: scHei - result.frame.height)
            showresult()
        }
        word.removeAll()
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
//             cell.imageView?.loadImageUsingCacheWithUrlString(urlStr: "http://static1.squarespace.com/static/525f350ee4b0fd74e5ba0495/t/53314e2be4b00782251d9427/1481141044684/?format=1500w")
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
        }
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.SuggestTableView {
            return scHei*0.06
        }else{
            return scHei*0.13
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
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
    
  
    func showresult() {
        var xPos:CGFloat = 10
        var yPos:CGFloat = 2.5
        var totalWid: CGFloat = 0
        result.isHidden  = false
        result = UIView(frame: CGRect(x: 0, y: 64, width: scWid, height: 20))
        result.backgroundColor = UIColor.gray
        
        for i in word {
            resultword = UILabel(frame: CGRect(x: xPos, y: yPos, width: scWid, height: scHei))
            resultword.text = " \(i) "
            resultword.backgroundColor = UIColor.red
            resultword.layer.cornerRadius = 3
            resultword.font = UIFont.boldSystemFont(ofSize: 13)
            resultword.numberOfLines = 1
            resultword.textColor = UIColor.white
            resultword.textAlignment = .center
            resultword.sizeToFit()
            resultword.clipsToBounds = true
            self.result.addSubview(resultword)
            xPos = xPos + resultword.frame.size.width + 5
            totalWid += resultword.frame.width
            print ("i : \(i)")
            print ("Width\(totalWid)")
            
            if totalWid >= scWid - 20{
                print("over")
                xPos = 10
                yPos = resultword.frame.size.height + 5
            }
        }
        
        //result = UIView(frame: CGRect(x: 0, y: 64, width: scWid, height: yPos+20))
        result.frame.size.height = yPos+20
        self.result.setNeedsDisplay()
        self.resultword.setNeedsDisplay()
        self.view.addSubview(result)
    }

    func buttonPressed(sender: AnyObject) {
        filterview.frame  = CGRect(x: 0, y: 65, width: scWid, height: scHei)
        filterview.backgroundColor = UIColor.white
        filterview.clipsToBounds = true
        filterview.layer.cornerRadius = 5
        self.view.addSubview(filterview)

        if filterview.isHidden{
            setView(view: filterview, hidden: false)
        } else {
            setView(view: filterview, hidden: true)
            FacSuggestTableView.backgroundColor = UIColor.clear
        }
    }
    
    func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.2, options: .transitionCrossDissolve, animations: { _ in
            view.isHidden = hidden
        }, completion: nil)
    }
    func Sidemenu() {
        
        MenuButton.target = SWRevealViewController()
        MenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
    }
    
    func CustomNavbar() {
        navigationController?.navigationBar.barTintColor = abacRed
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }

    
//    func Sidemenu() {
//
//            MenuButton.target = SWRevealViewController()
//            MenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
//           
//       
//    }
//    
////    func CustomNavbar() {
//        navigationController?.navigationBar.barTintColor = abacRed
//        navigationController?.navigationBar.isTranslucent = false
//        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
//        let myView: UIView = UIView(frame: CGRect(x: scWid * 0.4, y: 0, width: 200, height: 30))
//        titleButton.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
//        titleButton.setTitle("Recommendation", for: .normal)
//        titleButton.tintColor = UIColor.white
//        titleButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
//        
//        let image: UIImage = UIImage(named: "arrow-down")!
//        let myImageView: UIImageView = UIImageView(image: image)
//        myImageView.frame = CGRect(x: 175, y: 9, width: 15, height: 15)
//        myImageView.layer.masksToBounds = true
//        myView.addSubview(titleButton)
//        myView.backgroundColor = UIColor.clear
//        myView.addSubview(myImageView)
//        self.navigationItem.titleView = myView
//    }
    
    
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
            keyword.frame = CGRect(x: scWid*0.13, y: scWid*0.01, width: 0.23, height: scWid*0.08)
        }
        
        func checkAction(ui :AnyObject){
            if choose {
                checkBut.setImage(UIImage(named:"choose"), for: .normal)
            }else{
                checkBut.setImage(UIImage(named:"not choose"), for: .normal)
                
            }
        }
    }
}
