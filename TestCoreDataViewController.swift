

import UIKit
import GoogleMaps

class TestCoreDataViewController: UIViewController {

    var testview : UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        testview = UIView()
        view.addSubview(testview)
        testview.frame =  CGRect(x: 0, y: 0, width: scWid, height: 300)
        
        testview.backgroundColor = UIColor.blue
        let camera = GMSCameraPosition.camera(withLatitude: 100.627741, longitude: 13.753963, zoom: 10.0)
       let test = GMSMapView.map(withFrame: testview.frame, camera: camera)
//        testview.addSubview(test)
        testview = test
        view.addSubview(test)

//        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = mapView

    }
//    override func loadView() {
//        // Create a GMSCameraPosition that tells the map to display the
//        // coordinate -33.86,151.20 at zoom level 6.
//        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
//        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//        testview = mapView
//        
//        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = mapView
//    }
}
