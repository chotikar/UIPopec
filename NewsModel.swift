//
//  NewsModel.swift
//  UIPSOPEC
//
//  Created by Chotikar on 3/1/2560 BE.
//  Copyright © 2560 Senior Project. All rights reserved.
//

import Foundation

class NewsModel {
    
    var title : String!
    var description :String!
    var urlPicture : String!
    var source : String!
    
    init() {
        title = ""
        description = ""
        urlPicture = ""
        source = ""
    }
    
    init(dic : AnyObject) {
        title = dic["newstitle"] as! String
        description = dic["newsdescription"] as! String
        urlPicture = dic["newsurlpicture"] as! String
        source = dic["newssource"] as! String
    }
    
}
