//
//  ContactModel.swift
//  UIPSOPEC
//
//  Created by Popp on 3/25/17.
//  Copyright © 2017 Senior Project. All rights reserved.
//
import Foundation
class ContactModel {
    var Campusname : String
    var Addr : String
    var Telephone : String
    var Fax : String
    var Email : String
    
    init() {
        
        Campusname = "N/A"
        Addr = "N/A"
        Telephone  = "N/A"
        Fax = "N/A"
        Email = "N/A"
    }
    
    init(dic :AnyObject) {
        Campusname = dic["campusName"] as! String
        Addr = dic["address"] as! String
        Telephone = dic["telephone"] as! String
        Fax = dic["fax"] as! String
        Email = dic["mail"] as! String
    }
    
}
