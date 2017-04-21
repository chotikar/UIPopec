//
//  ResultModel.swift
//  UIPSOPEC
//
//  Created by Chotikar on 4/21/2560 BE.
//  Copyright © 2560 Senior Project. All rights reserved.
//

import Foundation
class ResultModle {
    var result : Bool!
    var message : String!
    
    init(){
        self.result = false
        self.message = "N/A"
    }
    
    init(dic : AnyObject){
        self.result = dic["result"] as? Bool
        self.message = dic["message"] as? String
    }
}
