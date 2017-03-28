
import UIKit
import MapKit
import SWRevealViewController

class LocationViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource,MKMapViewDelegate {
    @IBOutlet weak var MenuButton: UIBarButtonItem!
    
    @IBOutlet var mainMap : MKMapView!
    var scoll : UIView = {
        var sc = UIView()
        sc.frame = CGRect(x: 0, y: scHei*0.85, width: scWid, height: scHei)
        sc.layer.cornerRadius = 10
        return sc
    }()
    var showButton : UIButton = {
        
       var butShow = UIButton()
        butShow.frame =  CGRect(x: 0, y: 0, width: scWid, height: scHei*0.08)
        butShow.layer.cornerRadius = 10
        return butShow
    }()
    @IBOutlet weak var PlaceTableView: UITableView!

    
    var currentMap = CGFloat(0.9)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomNavbar()
        Sidemenu()
        self.title = "Map"
        self.view.addSubview(self.scoll)
        self.scoll.addSubview(showButton)
        self.scoll.addSubview(PlaceTableView)
        showButton.addTarget(self, action: #selector(showOrHideMap), for: .touchUpInside)
        mainMap.frame = CGRect(x: 0, y: 0, width: scWid, height: scHei*currentMap)
        scoll.backgroundColor = UIColor.brown
        showButton.backgroundColor = UIColor.red

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showOrHideMap(sender : AnyObject){
        if currentMap == 0.9 {
            currentMap = 0.1
            mainMap.frame = CGRect(x: 0, y: 0, width: scWid, height: scHei*currentMap)
            manageScroll(hei: mainMap.frame.height-20)
        }else{
             currentMap = 0.9
            mainMap.frame = CGRect(x: 0, y: 0, width: scWid, height: scHei*currentMap)
            manageScroll(hei: scHei*0.85)
        }
    }
    
    func manageScroll(hei : CGFloat){
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseIn], animations: {
            self.scoll.frame.origin.y = hei
            }, completion: nil)
        
        PlaceTableView.frame = CGRect(x: 0, y: self.showButton.frame.height+10, width: scWid, height: scHei*0.8)
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
    
    ///Show List of Place
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCellItem", for: indexPath) as! PlaceCell
        cell.name.text = "Place's name"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return scHei*0.1
    }
    
}


class PlaceCell : UITableViewCell {
    
    @IBOutlet var name: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(name)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        name.frame = CGRect(x: 0, y: 0, width: scWid, height: scHei*0.1)
        name.textAlignment = .center
        name.font = UIFont.boldSystemFont(ofSize: 20)
        name.textColor = UIColor.darkGray
    }
    
}
