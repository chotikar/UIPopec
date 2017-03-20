
import UIKit
import SWRevealViewController

class FacultyTableViewController: UITableViewController {

    @IBOutlet weak var MenuButton: UIBarButtonItem!
    
    var faclist : [FacultyModel] = []
    let facCellItemId = "FacultyCellItem"
    let ws = WebService.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Faculty"
        reloadTableViewInFac()
<<<<<<< HEAD
=======
        Sidemenu()
        CustomNavbar()
>>>>>>> e9cc3f05925b2f213f3f5aab4cfd000ef32f306e
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    
    func reloadTableViewInFac(){
        ws.GetFacultyWS() { (responseData: [FacultyModel], nil) in
            DispatchQueue.main.async( execute: {
                self.faclist = responseData
                self.tableView.reloadData()
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
        cell.logo.image = UIImage(named: "vme_logo")
        cell.facView.image = UIImage(named: "abaccl")
        cell.name.text = facultyDetail.facultyNameEn
        cell.abb.text = facultyDetail.facultyAbb
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return scHei*0.4
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "FacultyMajorLayout") as! FacultyMajorViewController
        vc.facultyCode = self.faclist[indexPath.row].faculyId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

class FacultyCell : UITableViewCell {
    
    @IBOutlet var facView : UIImageView!
    @IBOutlet var name : UILabel!
    @IBOutlet var abb : UILabel!
    @IBOutlet var logo : UIImageView!
    @IBOutlet var whiteBox : UIView!
    
   //   @IBOutlet var name : UILabel? = {
//    var nameL = UILabel()
//    nameL.font = UIFont.systemFont(ofSize: 10)
//    nameL.textColor = UIColor.white
//    nameL.textAlignment = NSTextAlignment.center
//        return nameL
//    }()
//    @IBOutlet var abb : UILabel? = {
//        var abbL = UILabel()
//        abbL.font = UIFont.boldSystemFont(ofSize: 20)
//        abbL.textColor = UIColor.white
//        return abbL
//    }()
  
     override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(facView)
        self.contentView.addSubview(logo)
        self.contentView.addSubview(name)
        self.contentView.addSubview(abb)
        self.contentView.addSubview(whiteBox)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        logo.frame.size = CGSize(width: scWid*0.3, height: scWid*0.3)
        logo.center = CGPoint(x: scWid/2, y: scWid*0.17)
//        logo.layer.cornerRadius = logo.frame.size.width/2
//        logo.clipsToBounds = true
        
        facView.frame = CGRect(x: 0, y: scHei*0.1, width: scWid, height: scHei*0.3)
        facView.alpha = 0.8
        
        var buttom = logo.frame.origin.y+scWid*0.3
        let speceAvi = (scHei*0.4)-buttom
        abb.frame = CGRect(x: scWid * 0.2, y: buttom+(speceAvi*0.15), width: scWid*0.6, height: speceAvi*0.3)
        abb.textAlignment = NSTextAlignment.center
        abb.font = UIFont.boldSystemFont(ofSize: 25)
        abb.textColor = UIColor.darkGray
        
        
        buttom = abb.frame.origin.y + (speceAvi*0.3)
        name.frame = CGRect(x: scWid * 0.05, y: buttom, width: scWid*0.9, height: speceAvi*0.3)
        name.textAlignment = NSTextAlignment.center
        name.font = UIFont.systemFont(ofSize: 15)
        name.textColor = UIColor.darkGray


        whiteBox.frame = CGRect(x: 0, y: abb.frame.origin.y, width: scWid, height: speceAvi*0.6)
        whiteBox.alpha = 0.65
    }
}
