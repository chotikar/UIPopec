//
//  LocationCell.swift
//  UIPSOPEC
//
//  Created by Chotikar on 2/28/2560 BE.
//  Copyright © 2560 Senior Project. All rights reserved.
//

import UIKit
import MapKit

class LocationCell : UITableViewCell, MKMapViewDelegate {
    var isObserving = false
    var location: CLLocation?
    @IBOutlet var loTitle : UILabel!
    @IBOutlet var loMap : MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //MapView
        loMap!.showsPointsOfInterest = true
        if let mapView = self.loMap {
            mapView.delegate = self
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func showLocation(location:CLLocation) {
        let orgLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = orgLocation
        loMap!.addAnnotation(dropPin)
        self.loMap?.setRegion(MKCoordinateRegionMakeWithDistance(orgLocation, 500, 500), animated: true)
    }
    
    // Height of cell
    class var expandingHeight: CGFloat { get { return scHei * 0.5 } }
    class var defauleHeight : CGFloat { get { return scHei * 0.1 } }
    
    func checckHei() {
        loMap.isHidden = (frame.size.height < LocationCell.expandingHeight)
        //        loImage.backgroundColor = UIColor.purple
        loMap.frame = CGRect(x: 0, y: scHei*0.2, width: scWid, height: scHei * 0.3)
    }
    
    
    func watchFrameChange(){
        if !isObserving {
            addObserver(self, forKeyPath: "frame", options: [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.initial], context: nil)
            isObserving = true
            
        }
    }
    
    func ignoreFrameChange(){
        if isObserving {
            removeObserver(self, forKeyPath: "frame")
            isObserving = false
        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            checckHei()
        }
    }
}

