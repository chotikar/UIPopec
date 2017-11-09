import Foundation
import UIKit
import SWRevealViewController

class SuggestionTableViewController : UIViewController,UITableViewDelegate,UITableViewDataSource  {
    
    @IBOutlet weak var FacSuggestTableView: UITableView!
    @IBOutlet weak var SuggestTableView:UITableView!
    @IBOutlet weak var MenuButton: UIBarButtonItem!
    @objc var word = [String]()
    @objc let result = UIView(frame: CGRect(x: 0, y: 0, width: scWid, height: 20))
    @objc var resultword: UILabel!
    var facSugWs = [FacSuggestionModel]()
    var keywordWs = [KeyWordModel]()
    @objc let filterview = UIView()
    let ws = WebService.self
    let fm = FunctionMutual.self
    @objc let facSuggestId = "facSugCellID"
    @objc let suggestId = "sugCellID"
    @objc var count:Int = 0
    @objc var titleButton = UIButton()
    @objc var doneBut = UIButton()
    var navWid : CGFloat!
    @objc var navIcon = UIImageView()
    @objc var activityiIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    var calHei:CGFloat!
    var lang : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lang = CRUDSettingValue.GetUserSetting()
        navWid = self.navigationItem.titleView?.frame.width
        titleButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        drawSuggestionFac()
        Sidemenu()
        CustomNavbar()
        stopIndicator()
        filterview.isHidden = true
        result.isHidden = false
        loadKeywordWS(lang: lang)
        setTableview()
        loadFacultyWS(sc:"0",lang: lang)
    }
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        //loadFacultyWS(sc:"0",lang:CRUDSettingValue.GetUserSetting())
    //    }
    //
    //    override func viewWillLayoutSubviews() {
    //
    //    }
    
    @objc func setTableview(){
        SuggestTableView.delegate = self
        SuggestTableView.dataSource = self
        SuggestTableView.register(UITableViewCell.self, forCellReuseIdentifier: suggestId)
        FacSuggestTableView.delegate = self
        FacSuggestTableView.dataSource = self
        FacSuggestTableView.register(UITableViewCell.self, forCellReuseIdentifier: facSuggestId)
    }
    
    @objc func drawSuggestionFac(){
        //        result = UIView(frame: CGRect(x: 0, y: 64, width: scWid, height: 20))
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
        doneBut.backgroundColor = appColor
        doneBut.addTarget(self, action: #selector(getChoose), for: .touchUpInside)
        FacSuggestTableView.frame = CGRect(x: 0, y: 0, width: scWid, height: scHei - 64)
        SuggestTableView.backgroundColor = UIColor.white
        SuggestTableView.frame = CGRect(x: 30, y: 10, width: scWid - 30, height: scHei * 0.81)
        SuggestTableView.separatorStyle = .none
    }
    
    @objc func loadFacultyWS(sc:String,lang:String){
        ws.GetSuggestionFacRequireWS(sugCode: sc, lang: lang){ (responseData: [FacSuggestionModel], nil) in
            DispatchQueue.main.async( execute: {
                self.facSugWs = responseData
                self.FacSuggestTableView.reloadData()
                self.stopIndicator()
            })
        }
    }
    
    @objc func loadKeywordWS(lang:String){
        ws.GetKeyWordRequireWS(lang: lang){ (responseData: [KeyWordModel], nil) in
            DispatchQueue.main.async( execute: {
                self.keywordWs = responseData
                self.SuggestTableView.reloadData()
                self.stopIndicator()
            })
        }
    }
    
    @objc func getChoose(sender : AnyObject){
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
            FacSuggestTableView.frame = CGRect(x: 0, y: 0, width: scWid, height: scHei - 64)
            for view in result.subviews {
                view.removeFromSuperview()
            }
        }
        else {
            FacSuggestTableView.frame = CGRect(x: 0, y: result.frame.height + 5, width: scWid, height: scHei - result.frame.height - 65)
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
            cell.imageView?.image = UIImage(named: fac.programAbb)
            cell.imageView?.contentMode = .scaleAspectFill
            cell.imageView?.layer.masksToBounds = true
            cell.imageView?.layer.cornerRadius = 10
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
            let vc = MajorViewController()
            vc.facultyFullName = programe.facultyName
            vc.facCode = String(programe.facultyID)
            vc.majorCode = String(programe.programID)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func startIndicator(){
        self.activityiIndicator.center = self.view.center
        self.activityiIndicator.hidesWhenStopped = true
        self.activityiIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityiIndicator)
        activityiIndicator.startAnimating()
    }
    
    @objc func stopIndicator(){
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
    
    @objc func editChoose(i: Int){
        
        if self.keywordWs[i].choose {
            self.keywordWs[i].choose = false
            self.keywordWs[i].chooseImg = "not choose"
        }else{
            self.keywordWs[i].choose = true
            self.keywordWs[i].chooseImg = "choose"
        }
        self.SuggestTableView.reloadData()
        
    }
    
    @objc func showresult() {
        var xPos:CGFloat = 10
        var yPos:CGFloat = 2.5
        var totalWid: CGFloat = 0
        if (resultword != nil && resultword.text?.isEmpty == false) {
            for view in result.subviews {
                view.removeFromSuperview()
            }
        }
        for i in word {
            resultword = UILabel(frame: CGRect(x: xPos, y: yPos, width: scWid, height: scHei))
            resultword.text = " \(i) "
            resultword.backgroundColor = appColor
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
            print ("Width\(totalWid)")
            if totalWid >= scWid - 20{
                print("over")
                xPos = 10
                yPos = resultword.frame.size.height + 5
            }
        }
        result.frame.size.height = yPos+20
    }
    
    @objc func buttonPressed(sender: AnyObject) {
        filterview.frame  = CGRect(x: 0, y: 0, width: scWid, height: scHei)
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
    
    @objc func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.2, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        }, completion: nil)
    }
    
    @objc func Sidemenu() {
        MenuButton.target = SWRevealViewController()
        MenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
    }
    
    @objc func CustomNavbar() {
        navigationController?.navigationBar.barTintColor = appColor
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white];    navigationController?.navigationBar.isTranslucent = false
        let myView: UIView = UIView(frame: CGRect(x: scWid * 0.4, y: 0, width: 200, height: 30))
        titleButton.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        titleButton.setTitle(lang == "E" ? "Recommendation" : "แนะนำหลักสูตร", for: .normal)
        titleButton.tintColor = UIColor.white
        titleButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        let image: UIImage = UIImage(named: "arrow-down")!
        let myImageView: UIImageView = UIImageView(image: image)
        myImageView.frame = CGRect(x: 175, y: 9, width: 15, height: 15)
        myImageView.layer.masksToBounds = true
        myView.addSubview(titleButton)
        myView.backgroundColor = UIColor.clear
        myView.addSubview(myImageView)
        self.navigationItem.titleView = myView
    }
    
    class SuggestCell : UITableViewCell {
        @IBOutlet var checkBut : UIButton!
        @IBOutlet var keyword : UILabel!
        let fm = FunctionMutual.self
        @objc var choose = false
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
        @objc func checkAction(ui :AnyObject){
            if choose {
                checkBut.setImage(UIImage(named:"choose"), for: .normal)
            }
            else{
                checkBut.setImage(UIImage(named:"not choose"), for: .normal)
            }
        }
    }
}


















//class SuggestionTableViewController : UIViewController,UITableViewDelegate,UITableViewDataSource  {
//
//    @IBOutlet weak var FacSuggestTableView: UITableView!
//    @IBOutlet weak var SuggestTableView:UITableView!
//    @IBOutlet weak var MenuButton: UIBarButtonItem!
//    var word = [String]()
//    let result = UIView(frame: CGRect(x: 0, y: 0, width: scWid, height: 20))
//    var resultword: UILabel!
//    var facSugWs = [FacSuggestionModel]()
//    var keywordWs = [KeyWordModel]()
//    let filterview = UIView()
//    let ws = WebService.self
//    let fm = FunctionMutual.self
//    let facSuggestId = "facSugCellID"
//    let suggestId = "sugCellID"
//    var count:Int = 0
//    var titleButton = UIButton()
//    var doneBut = UIButton()
//    var navWid : CGFloat!
//    var navIcon = UIImageView()
//    var activityiIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
//    var calHei:CGFloat!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        navWid = self.navigationItem.titleView?.frame.width
//        titleButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
//        drawSuggestionFac()
//        setTableview()
//        Sidemenu()
//        CustomNavbar()
//        stopIndicator()
//        loadFacultyWS(sc:"0",lang:CRUDSettingValue.GetUserSetting())
//        loadKeywordWS(lang:CRUDSettingValue.GetUserSetting())
//        filterview.isHidden = true
//        result.isHidden = false
//    }
//
//    func setTableview(){
//        SuggestTableView.delegate = self
//        SuggestTableView.dataSource = self
//        SuggestTableView.register(UITableViewCell.self, forCellReuseIdentifier: suggestId)
//        FacSuggestTableView.delegate = self
//        FacSuggestTableView.dataSource = self
//        FacSuggestTableView.register(UITableViewCell.self, forCellReuseIdentifier: facSuggestId)
//    }
//
//    func drawSuggestionFac(){
//        //        result = UIView(frame: CGRect(x: 0, y: 64, width: scWid, height: 20))
//        self.view.addSubview(FacSuggestTableView)
//        self.filterview.addSubview(SuggestTableView)
//        self.filterview.addSubview(doneBut)
//        self.view.addSubview(result)
//
//        doneBut.setTitle("Done", for: .normal)
//        doneBut.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
//        doneBut.layer.cornerRadius = 5
//        doneBut.clipsToBounds = true
//        doneBut.frame = CGRect(x: filterview.frame.width / 2, y: scHei*0.85, width: scWid*0.5, height: scHei*0.05 )
//        doneBut.center = CGPoint(x: scWid / 2, y: scHei * 0.85)
//        doneBut.backgroundColor = appColor
//        doneBut.addTarget(self, action: #selector(getChoose), for: .touchUpInside)
//        FacSuggestTableView.frame = CGRect(x: 0, y: 0, width: scWid, height: scHei - 64)
//        SuggestTableView.backgroundColor = UIColor.white
//        SuggestTableView.frame = CGRect(x: 30, y: 10, width: scWid - 30, height: scHei * 0.81)
//        SuggestTableView.separatorStyle = .none
//    }
//
//    func loadFacultyWS(sc:String,lang:String){
//        ws.GetSuggestionFacRequireWS(sugCode: sc, lang: lang){ (responseData: [FacSuggestionModel], nil) in
//            DispatchQueue.main.async( execute: {
//                self.facSugWs = responseData
//                self.FacSuggestTableView.reloadData()
//                self.stopIndicator()
//            })
//        }
//    }
//
//    func loadKeywordWS(lang:String){
//        ws.GetKeyWordRequireWS(lang: lang){ (responseData: [KeyWordModel], nil) in
//            DispatchQueue.main.async( execute: {
//                self.keywordWs = responseData
//                self.SuggestTableView.reloadData()
//                self.stopIndicator()
//            })
//        }
//    }
//
//    func getChoose(sender : AnyObject){
//        var code = ""
//        for i in self.keywordWs {
//            if i.choose{
//                code = code + String(i.keywordID) + ";"
//                word.append(String(i.keyword))
//            }
//        }
//        self.startIndicator()
//        loadFacultyWS(sc: "\(code)0", lang: CRUDSettingValue.GetUserSetting())
//        if word.isEmpty {
//            FacSuggestTableView.frame = CGRect(x: 0, y: 0, width: scWid, height: scHei - 64)
//            for view in result.subviews {
//                view.removeFromSuperview()
//            }
//        }
//        else {
//            FacSuggestTableView.frame = CGRect(x: 0, y: result.frame.height + 5, width: scWid, height: scHei - result.frame.height - 65)
//            showresult()
//        }
//        word.removeAll()
//        buttonPressed(sender: UIButton())
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tableView == self.SuggestTableView {
//            return self.keywordWs.count
//        }else{
//            return self.facSugWs.count
//        }
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var cell = UITableViewCell()
//        cell.selectionStyle = .none
//        if tableView == self.FacSuggestTableView {
//            cell = tableView.dequeueReusableCell(withIdentifier: facSuggestId, for: indexPath)
//            let fac = self.facSugWs[indexPath.row]
//            cell.textLabel?.text = fac.programName
//            cell.detailTextLabel?.text = fac.facultyName
//            cell.imageView?.image = UIImage(named: fac.programAbb)
//            cell.imageView?.contentMode = .scaleAspectFill
//            cell.imageView?.layer.masksToBounds = true
//            cell.imageView?.layer.cornerRadius = 10
//        }
//
//        if tableView == self.SuggestTableView {
//            cell = tableView.dequeueReusableCell(withIdentifier: suggestId, for: indexPath)
//            let key = self.keywordWs[indexPath.row]
//            cell.textLabel?.text = key.keyword
//            cell.imageView?.image = UIImage(named:key.chooseImg)
//        }
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if tableView == self.SuggestTableView {
//            editChoose(i: indexPath.row)
//        }
//
//        if tableView == self.FacSuggestTableView{
//            let programe = self.facSugWs[indexPath.row]
//            let vc = storyboard?.instantiateViewController(withIdentifier: "MajorLayout") as! MajorViewController
//            vc.facultyFullName = programe.facultyName
//            vc.facCode = programe.facultyID
//            vc.majorCode = programe.programID
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//    }
//    func startIndicator(){
//        self.activityiIndicator.center = self.view.center
//        self.activityiIndicator.hidesWhenStopped = true
//        self.activityiIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
//        view.addSubview(activityiIndicator)
//        activityiIndicator.startAnimating()
//    }
//    func stopIndicator(){
//        self.activityiIndicator.stopAnimating()
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if tableView == self.SuggestTableView {
//            return scHei*0.06
//        }else{
//            return scHei*0.13
//        }
//    }
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.backgroundColor = UIColor.clear
//    }
//    func editChoose(i: Int){
//
//        if self.keywordWs[i].choose {
//            self.keywordWs[i].choose = false
//            self.keywordWs[i].chooseImg = "not choose"
//        }else{
//            self.keywordWs[i].choose = true
//            self.keywordWs[i].chooseImg = "choose"
//        }
//        self.SuggestTableView.reloadData()
//
//    }
//    func showresult() {
//        var xPos:CGFloat = 10
//        var yPos:CGFloat = 2.5
//        var totalWid: CGFloat = 0
//        if (resultword != nil && resultword.text?.isEmpty == false) {
//            for view in result.subviews {
//                view.removeFromSuperview()
//            }
//        }
//        for i in word {
//            resultword = UILabel(frame: CGRect(x: xPos, y: yPos, width: scWid, height: scHei))
//            resultword.text = " \(i) "
//            resultword.backgroundColor = appColor
//            resultword.layer.cornerRadius = 3
//            resultword.font = UIFont.boldSystemFont(ofSize: 13)
//            resultword.numberOfLines = 1
//            resultword.textColor = UIColor.white
//            resultword.textAlignment = .center
//            resultword.sizeToFit()
//            resultword.clipsToBounds = true
//            self.result.addSubview(resultword)
//            xPos = xPos + resultword.frame.size.width + 5
//            totalWid += resultword.frame.width
//            print ("Width\(totalWid)")
//            if totalWid >= scWid - 20{
//                print("over")
//                xPos = 10
//                yPos = resultword.frame.size.height + 5
//            }
//        }
//        result.frame.size.height = yPos+20
//    }
//
//    func buttonPressed(sender: AnyObject) {
//        filterview.frame  = CGRect(x: 0, y: 0, width: scWid, height: scHei)
//        filterview.backgroundColor = UIColor.white
//        filterview.clipsToBounds = true
//        filterview.layer.cornerRadius = 5
//        self.view.addSubview(filterview)
//        if filterview.isHidden{
//            setView(view: filterview, hidden: false)
//        } else {
//            setView(view: filterview, hidden: true)
//            FacSuggestTableView.backgroundColor = UIColor.clear
//        }
//    }
//
//    func setView(view: UIView, hidden: Bool) {
//        UIView.transition(with: view, duration: 0.2, options: .transitionCrossDissolve, animations: { _ in
//            view.isHidden = hidden
//        }, completion: nil)
//    }
//
//    func Sidemenu() {
//        MenuButton.target = SWRevealViewController()
//        MenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
//    }
//
//    func CustomNavbar() {
//        navigationController?.navigationBar.barTintColor = appColor
//        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
//        navigationController?.navigationBar.isTranslucent = false
//        let myView: UIView = UIView(frame: CGRect(x: scWid * 0.4, y: 0, width: 200, height: 30))
//        titleButton.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
//        titleButton.setTitle("Recommendation", for: .normal)
//        titleButton.tintColor = UIColor.white
//        titleButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
//        let image: UIImage = UIImage(named: "arrow-down")!
//        let myImageView: UIImageView = UIImageView(image: image)
//        myImageView.frame = CGRect(x: 175, y: 9, width: 15, height: 15)
//        myImageView.layer.masksToBounds = true
//        myView.addSubview(titleButton)
//        myView.backgroundColor = UIColor.clear
//        myView.addSubview(myImageView)
//        self.navigationItem.titleView = myView
//    }
//
//    class SuggestCell : UITableViewCell {
//        @IBOutlet var checkBut : UIButton!
//        @IBOutlet var keyword : UILabel!
//        let fm = FunctionMutual.self
//        var choose = false
//        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//            super.init(style: style, reuseIdentifier: reuseIdentifier)
//            self.contentView.addSubview(checkBut)
//            self.contentView.addSubview(keyword)
//        }
//        required init?(coder aDecoder: NSCoder) {
//            super.init(coder: aDecoder)
//        }
//        override func layoutSubviews() {
//            super.layoutSubviews()
//            checkBut.frame = CGRect(x: scWid*0.05, y: scWid*0.01, width: scWid*0.08, height: scWid*0.08)
//            checkBut.addTarget(self, action: #selector(checkAction), for: .touchUpInside)
//            keyword.frame = CGRect(x: scWid*0.13, y: scWid*0.01, width: 0.23, height: scWid*0.08)
//        }
//        func checkAction(ui :AnyObject){
//            if choose {
//                checkBut.setImage(UIImage(named:"choose"), for: .normal)
//            }
//            else{
//                checkBut.setImage(UIImage(named:"not choose"), for: .normal)
//            }
//        }
//    }
//}

