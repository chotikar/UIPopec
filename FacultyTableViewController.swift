import Foundation
import UIKit
import SWRevealViewController

class FacultyTableViewController: UITableViewController {
    
    @IBOutlet weak var MenuButton: UIBarButtonItem!
    @objc var activityiIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    var faclist : [FacultyModel] = []
    @objc let facCellItemId = "FacultyCellItem"
    let ws = WebService.self
    var lang : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lang = CRUDSettingValue.GetUserSetting()
        self.title = lang == "E" ? "Faculty" : "คณะ"
        startIndicator()
        Sidemenu()
        CustomNavbar()
        reloadTableViewInFac(lang: lang)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @objc func Sidemenu() {
        MenuButton.target = SWRevealViewController()
        MenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
    }
    
    @objc func CustomNavbar() {
        navigationController?.navigationBar.barTintColor = appColor
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    @objc func reloadTableViewInFac(lang:String){
        ws.GetFacultyWS(language: lang) { (responseData: [FacultyModel], nil) in
            DispatchQueue.main.async( execute: {
                self.faclist = responseData
                self.tableView.reloadData()
                self.stopIndicator()
            })
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.faclist.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: facCellItemId, for: indexPath) as! FacultyCell
        cell.selectionStyle = .none
        let facultyDetail = self.faclist[indexPath.row]
        cell.facView.loadImageUsingCacheWithUrlString(urlStr: facultyDetail.imageURL)
        cell.name.text = facultyDetail.facultyName
        cell.keyword.text = facultyDetail.facultyKeyword
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return scHei*0.31
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = FacultyMajorViewController()
        vc.facultyCode = self.faclist[indexPath.row].faculyId
        vc.loadInfo = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


class FacultyCell : UITableViewCell {

    let fm = FunctionMutual.self

    @IBOutlet var facView : UIImageView!
    @IBOutlet var name : UILabel!
    @IBOutlet var whiteBox : UIImageView!
    @IBOutlet var keyword : UILabel!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(facView)
        self.contentView.addSubview(name)
        self.contentView.addSubview(whiteBox)
        self.contentView.addSubview(keyword)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        facView.frame = CGRect(x: 0, y: 0, width: scWid, height: scHei*0.3)
        facView.alpha = 0.8
//        facView.image = UIImage(named: "abaccl")

        keyword.frame = CGRect(x: scWid * 0.05, y:scHei*0.17 , width: scWid*0.9, height: scHei*0.1)
        keyword.textAlignment = NSTextAlignment.left
        keyword.font = fm.setFontSizeLight(fs: 25)
        keyword.textColor = UIColor.white

        name.frame = CGRect(x: scWid * 0.05, y: scHei*0.22, width: scWid*0.9, height: scHei*0.1)
        name.textAlignment = NSTextAlignment.left
        name.font = fm.setFontSizeLight(fs: 15)
        name.textColor = UIColor.white

        whiteBox.frame = CGRect(x: 0, y: 0, width: scWid, height: scHei*0.3)
        whiteBox.image = UIImage(named: "black-gradient")

    }
}
