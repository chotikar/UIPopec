
import UIKit
import GoogleMaps
import SWRevealViewController
//class TestGoogleViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//    override func loadView() {
//        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 17.0)
//        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
////       view.frame = CGRect(x: 0, y: 50, width: scWid, height: scHei * 0.5)
//        view = mapView
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = mapView
//    }
//
//}

class TestGoogleViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    
    let fm = FunctionMutual.self
    @IBOutlet weak var MenuButton: UIBarButtonItem!
    
    @IBOutlet var mainMap : GMSMapView!
    let uiv : UIView = {
        let uiv = UIView()
        uiv.frame = CGRect(x: 0, y: 64, width: scWid, height: scHei)
        return uiv
    }()
    var scoll : UIScrollView = {
        var sc = UIScrollView ()
        sc.frame = CGRect(x: 0, y: scHei*0.85, width: scWid, height: scHei)
        sc.layer.cornerRadius = 10
        return sc
    }()
    var showButton : UIButton = {
        var butShow = UIButton()
        butShow.frame =  CGRect(x: 0, y: 0, width: scWid, height: (scHei-64)*0.08)
        butShow.backgroundColor = UIColor(colorLiteralRed: 228/225, green: 228/225, blue: 228/225, alpha: 1)
        butShow.layer.cornerRadius = 10
        return butShow
    }()
    
    var symIcon : UIImageView = {
        var ci = UIImageView()
        ci.frame = CGRect(x: (scWid*0.92)/2.0, y: 5, width: scWid*0.08, height: scWid*0.08)
        ci.image = UIImage(named: "up")
        return ci
    }()
    @IBOutlet weak var PlaceTableView: UITableView!
    var navigationBarHeight = CGFloat(0.0)
    
    var currentMap = CGFloat(0.1)
    let ws = WebService.self
    var placeList : [PlaceModel] = []
    let regionRadius: CLLocationDistance = 200
    var activityiIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomNavbar()
        Sidemenu()
        self.title = "Map"
        startIndicator()
        navigationBarHeight = (self.navigationController?.navigationBar.bounds.size.height)!
        setscreen(nav: navigationBarHeight)
        reloadTableViewInLocation(language: CRUDSettingValue.GetUserSetting())
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
    
    
    func setscreen(nav:CGFloat){
        self.view.addSubview(uiv)
        self.uiv.addSubview(mainMap)
        self.uiv.addSubview(scoll)
        self.scoll.addSubview(self.showButton)
        self.scoll.addSubview(self.PlaceTableView)
        self.showButton.addSubview(self.symIcon)
        self.showButton.addTarget(self, action: #selector(showOrHideMap), for: .touchUpInside)
        self.scoll.frame = CGRect(x: 0, y: nav, width: scWid, height: scHei-nav)
        self.showOrHideMap(sender: UIButton())
        
    }
    
    func setMainMap (la : Double , lo : Double, placeName : String) {
        self.mainMap.reloadInputViews()
        
        let camera = GMSCameraPosition.camera(withLatitude: la, longitude: lo, zoom: 17.0)
        
        self.mainMap = GMSMapView.map(withFrame: mainMap.frame, camera: camera)
        let currentLocation = CLLocationCoordinate2D(latitude: la, longitude: lo)
        let marker = GMSMarker(position: currentLocation)
        marker.title = placeName
        marker.map = self.mainMap
    }
    
    func reloadTableViewInLocation(language:String){
        self.setMainMap(la: 13.612320, lo: 100.836808,placeName: "Assumption University")
        ws.GetAllPlaceWS(lang:language){ (responseData: [PlaceModel], nil) in
            DispatchQueue.main.async( execute: {
                self.placeList = responseData
                self.PlaceTableView.reloadData()
                self.stopIndicator()
            })
        }
    }
    
    func showOrHideMap(sender : AnyObject){
        if currentMap == 0.9 {
            currentMap = 0.1
            mainMap.frame = CGRect(x: 0, y: 0, width: scWid, height: (scHei-64)*currentMap)
            manageScroll(hei:(scHei-64)*currentMap,symStr:"up")
        }else{
            currentMap = 0.9
            mainMap.frame = CGRect(x: 0, y: 0, width: scWid, height: (scHei-64)*currentMap)
            manageScroll(hei: (scHei-64)*currentMap,symStr:"down")
        }
    }
    
    func manageScroll(hei : CGFloat, symStr : String){
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseIn], animations: {
            self.scoll.frame.origin.y = hei
            self.symIcon.image = UIImage(named: symStr)
        }, completion: nil)
        
        PlaceTableView.frame = CGRect(x: 0, y: self.showButton.frame.height+5, width: scWid, height: (scHei-64)*0.8)
    }
    
    func Sidemenu() {
//        
//        MenuButton.target = SWRevealViewController()
//        MenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
    }
    
    func CustomNavbar() {
        navigationController?.navigationBar.barTintColor = appColor
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
    }
    
    ///Show List of Place
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.placeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlacesCellItem", for: indexPath) as! PlacesCell
        cell.name.text = self.placeList[indexPath.row].buildingName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let locate = self.placeList[indexPath.row]
        setMainMap(la: Double(locate.latitude)!, lo: Double(locate.longtitude)!, placeName: locate.buildingName)
        showOrHideMap(sender: UIButton())
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return scHei*0.09
    }
}


class PlacesCell : UITableViewCell {
    
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











//import UIKit
//import GoogleMaps
//class TestGoogleViewController: UIViewController {
//
//    
//    override func loadView() {
//        // Create a GMSCameraPosition that tells the map to display the
//        // coordinate -33.86,151.20 at zoom level 6.
//        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
//        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
////       view.frame = CGRect(x: 0, y: 50, width: scWid, height: scHei * 0.5)
//        view = mapView
//        
//        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = mapView
//    }   
//
//}
