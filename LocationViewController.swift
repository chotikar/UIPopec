
import UIKit
import MapKit
import SWRevealViewController


class LocationViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource,MKMapViewDelegate {
    //http://www.supanattoy.com:89/Location/GetAllLocation?language=T
    let fm = FunctionMutual.self
    @IBOutlet weak var MenuButton: UIBarButtonItem!
    
    @IBOutlet var mainMap : MKMapView!
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
            //FunctionMutual.getColorrgb(r: 225, g: 225, b: 225, al: 1)
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
    
    func setMainMap (la : String , lo : String) {
        self.mainMap.reloadInputViews()
        let location = CLLocation(latitude: CLLocationDegrees(la)!, longitude: CLLocationDegrees(lo)!)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, self.regionRadius*2.0, self.regionRadius*2.0)
        self.mainMap.setRegion(coordinateRegion, animated: true)
    }
    
    func reloadTableViewInLocation(language:String){
        self.setMainMap(la: "13.612320", lo: "100.836808")
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
        return scHei*0.09
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
