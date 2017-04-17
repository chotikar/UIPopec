//
//  FacultyMajorModel.swift
//  UIPSOPEC
//
//  Created by Chotikar on 3/15/2560 BE.
//  Copyright © 2560 Senior Project. All rights reserved.
//

import Foundation

class FacultyMajorModel {
    
    var faculyId : Int!
    var facultyName : String!
    var facultyAbb : String!
    var imageURL :String!
    var description: String!
    var facebook: String!
    var webpage: String!
    var email: String!
    var phone: String!
    var marjorList = [MajorModel]()
  //  var location:
    
    init() {
        faculyId = 99999
        facultyName = "N/A"
        facultyAbb = "N/A"
        imageURL = "N/A"
        description = "N/A"
        facebook = "N/A"
        webpage = "N/A"
        email = "N/A"
        phone = "N/A"
    }
    
    init(dic : AnyObject) {
        faculyId = dic["facultyID"] as! Int
        facultyName = dic["facultyName"] as! String
        facultyAbb = dic["facultyAbb"] as! String
        imageURL = (dic["imageURL"] as? String ?? "N/A")
        description = (dic["description"] as? String ?? "N/A")
        facebook = (dic["facebook"] as? String ?? "N/A")
        webpage = (dic["webpage"] as? String ?? "N/A")
        email = (dic["email"] as? String ?? "N/A")
        phone = (dic["phone"] as? String ?? "N/A")
        
        let mList = dic["departmentlist"] as? [[String: AnyObject]]
        for i in mList! {
            marjorList.append(MajorModel(dic:i as AnyObject))
        }
    }

}

class MajorModel {
    
    var departmentId : Int!
    var departmentName: String!
    var degree: Int!
    var degreeName : String!
    var departmentAbb: String!
    var imageURL: String!
    var description: String!
    
    init(){
        departmentId = 99999
        departmentName = "N/A"
        degree = 99999
        degreeName = "N/A"
        departmentAbb = "N/A"
        imageURL = "N/A"
        description = "N/A"
    }
    
    init(dic :AnyObject) {
        departmentId = dic["departmentID"]  as! Int
        departmentName = dic["departmentName"] as! String
        degree = dic["degree"] as! Int
        degreeName = (dic["degreeName"] as? String ?? "N/A")
        departmentAbb = (dic["departmentAbb"] as? String ?? "N/A")
        imageURL = (dic["imageURL"] as? String ?? "N/A")
        description = (dic["description"] as? String ?? "N/A")
    }
    
}
