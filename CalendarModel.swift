//
//  CalendarModel.swift
//  UIPSOPEC
//
//  Created by Popp on 4/15/17.
//  Copyright © 2017 Senior Project. All rights reserved.
//
import Foundation

class CalendarModel {
    
    var Date: String!
    var Topic: String!
    var type: Int!
//    var Typename: String!
    
    init() {
        Date = "N/A"
        Topic = "N/A"
        type = 9999
//        Typename = "N/A"
    }
    
    init(dic: AnyObject) {
        Date = dic["Date"] as! String
        Topic = dic["Topic"] as! String
        type = dic["Type"] as! Int
//        Typename = dic["Typename"] as! String
    }
}


