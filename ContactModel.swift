//
//  ContactModel.swift
//  UIPSOPEC
//
//  Created by Popp on 3/25/17.
//  Copyright © 2017 Senior Project. All rights reserved.
//
import Foundation
class ContactModel {
    var CampusnameEn : String
    var Latitude : String
    var Longtitude : String
    var AddrEn : String
    var AddrTh : String
    var Telephone : String
    var Fax : String
    var Email : String
    
    init() {
        
        CampusnameEn = "N/A"
        Latitude = "N/A"
        Longtitude = "N/A"
        AddrEn = "N/A"
        AddrTh = "N/A"
        Telephone  = "N/A"
        Fax = "N/A"
        Email = "N/A"
    }
    
    init(dic :AnyObject) {
        CampusnameEn = dic["campusName"] as! String
        Latitude = dic["latitude"] as! String
        Longtitude  = dic["longtitude"] as! String
        AddrEn = dic["addressEN"] as! String
        AddrTh = dic["addressTH"] as! String
        Telephone = dic["telephone"] as! String
        Fax = dic["fax"] as! String
        Email = dic["mail"] as! String
    }
    
}
