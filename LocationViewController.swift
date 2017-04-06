
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
    let ws = WebService.self
    var placeList : [PlaceModel] = []

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
        reloadTableViewInLocation()
        setMainMap(la: "13.612320", lo: "100.836808")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setMainMap (la : String , lo : String) {
        let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(la)!, longitude: CLLocationDegrees(lo)!)
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.006, longitudeDelta: 0.006))
        self.mainMap.setRegion(region, animated: true)
        self.reloadInputViews()
    }
    
    func reloadTableViewInLocation(){
        ws.GetAllPlaceWS(){ (responseData: [PlaceModel], nil) in
            DispatchQueue.main.async( execute: {
                self.placeList = responseData
                self.PlaceTableView.reloadData()
            })
        }
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
        navigationController?.navigationBar.barTintColor = abacRed
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
    }

    ///Show List of Place
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.placeList.count
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCellItem", for: indexPath) as! PlaceCell
        cell.name.text = self.placeList[indexPath.row].buildingName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let locate = self.placeList[indexPath.row]
        setMainMap(la: locate.latitude, lo: locate.longtitude)
        showOrHideMap(sender: UIButton())
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return scHei*0.1
    }
    
}


class PlaceCell : UITableViewCell {
    
    @IBOutlet var name: UILabel!
    let fm = FunctionMutual.self
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
        name.font = fm.setFontSizeLight(fs: 20)
        name.textColor = UIColor.darkGray
    }
    
}
