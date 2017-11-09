
import UIKit
import GoogleMaps
import SWRevealViewController

class MapDirectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    let fm = FunctionMutual.self
    @IBOutlet weak var MenuButton: UIBarButtonItem!
    var mainMap = UIView()
    let uiv: UIView = {
        let uiv = UIView()
        uiv.frame = CGRect(x: 0, y: 0, width: scWid, height: scHei)
        return uiv
    }()
    var scoll: UIScrollView = {
        var sc = UIScrollView ()
        sc.frame = CGRect(x: 0, y: scHei*0.85, width: scWid, height: scHei)
        sc.backgroundColor = UIColor.white
        return sc
    }()
    var showButton: UIButton = {
        var butShow = UIButton()
        butShow.frame =  CGRect(x: 0, y: 0, width: scWid, height: (scHei-64)*0.08)
        butShow.backgroundColor = UIColor(colorLiteralRed: 228/225, green: 228/225, blue: 228/225, alpha: 1)
        return butShow
    }()
    
    var symIcon: UIImageView = {
        var ci = UIImageView()
        ci.frame = CGRect(x: (scWid*0.92)/2.0, y: 5, width: scWid*0.08, height: scWid*0.08)
        ci.image = UIImage(named: "up")
        return ci
    }()
    @IBOutlet weak var PlaceTableView: UITableView!
    var currentMap = CGFloat(0.1)
    let ws = WebService.self
    var placeList: [PlaceModel]!
    var regionRadius: CLLocationDistance = 200
    var activityiIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var currentLongtitude: CLLocationDegrees!
    var currentLatitude: CLLocationDegrees!
    var currentName: String!
    var currentSnippet: String!
    var lang: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lang = CRUDSettingValue.GetUserSetting()
        CustomNavbar()
        Sidemenu()
        self.title = lang == "E" ? "Map" : "แผนที่"
        startIndicator()
        setscreen(nav:0)
        reloadTableViewInLocation(language: lang)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        view.removeFromSuperview()
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
        self.view.addSubview(mainMap)
        self.view.addSubview(scoll)
        self.scoll.addSubview(self.showButton)
        self.scoll.addSubview(self.PlaceTableView)
        self.showButton.addSubview(self.symIcon)
        self.showButton.addTarget(self, action: #selector(showOrHideMap), for: .touchUpInside)
        PlaceTableView.delegate = self
        PlaceTableView.dataSource = self
        PlaceTableView.register(PlaceCell.self, forCellReuseIdentifier: "PlaceCellItem")
        self.scoll.frame = CGRect(x: 0, y: 0, width: scWid, height: scHei-nav)
        self.scoll.layer.cornerRadius = 13
        currentLongtitude =  currentLongtitude ?? CLLocationDegrees(100.8355103)
        currentLatitude = currentLatitude ?? CLLocationDegrees(13.6120822)
        currentName = currentName ?? "Assumption University"
        self.showOrHideMap(sender: UIButton())
    }
    
    func setMainMap () {
        let camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongtitude, zoom: 17.0)
        let mainmap = GMSMapView.map(withFrame: mainMap.frame, camera: camera)
        mainMap.addSubview(mainmap)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongtitude)
        marker.title = currentName
//        marker.snippet = currentSnippet
        marker.map = mainmap
    }
    
    func reloadTableViewInLocation(language:String) {
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
            mainMap.frame = CGRect(x: 0, y: 0, width: scWid, height: (scHei - 64) * currentMap)
            mainMap.backgroundColor = UIColor.red
            manageScroll(hei: (scHei - 64) * currentMap, symStr: "up")
        }else{
            currentMap = 0.9
            mainMap.frame = CGRect(x: 0, y: 0, width: scWid, height: (scHei - 64) * currentMap)
            mainMap.backgroundColor = UIColor.yellow
            manageScroll(hei: (scHei - 64) * currentMap, symStr: "down")
        }
        setMainMap()
    }
    
    func manageScroll(hei : CGFloat, symStr : String){
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseIn], animations: {
            self.scoll.frame.origin.y = hei
            self.scoll.layer.cornerRadius = 13
            self.symIcon.image = UIImage(named: symStr)
        }, completion: nil)
        PlaceTableView.frame = CGRect(x: 0, y: self.showButton.frame.height+5, width: scWid, height: (scHei-64)*0.8)
    }
    
    ///Show List of Place
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.placeList?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PlaceCell()
        cell.name.text = self.placeList[indexPath.row].buildingName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let locate = self.placeList[indexPath.row]
        currentLatitude = CLLocationDegrees(locate.latitude)!
        currentLongtitude = CLLocationDegrees(locate.longtitude)!
        currentName = locate.buildingName
        currentSnippet = ""
        showOrHideMap(sender: UIButton())
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return scHei*0.09
    }
    
    func Sidemenu() {
        
        MenuButton.target = SWRevealViewController()
        MenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
    }
    
    func CustomNavbar() {
        navigationController?.navigationBar.barTintColor = appColor
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
}
