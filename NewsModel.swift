//
//  NewsModel.swift
//  UIPSOPEC
//
//  Created by Chotikar on 3/1/2560 BE.
//  Copyright © 2560 Senior Project. All rights reserved.
//

import Foundation

class NewsModel {
    
    var newsId : Int!
    var topicEn : String!
    var topicTh : String!
    var typeId : Int!
    var typeName : String!
    var descriptionEn : String!
    var descriptionTh : String!
    var imageURL : String!
    
    
    init() {
        newsId = 999999999
        topicEn = "N/A"
        topicTh = "N/A"
        typeId = 999999999
        typeName = "N/A"
        descriptionEn = "N/A"
        descriptionTh = "N/A"
        imageURL = "N/A"
        
    }
    
    init(dic : AnyObject) {
        
        newsId = dic["NewsID"] as? Int
        topicEn = dic["TopicEN"] as? String
        topicTh = dic["TopicTH"] as? String
        typeId = dic["TypeID"] as? Int
        typeName = dic["TypeName"] as? String
        descriptionEn = dic["DescriptionEN"] as? String
        descriptionTh = dic["DescriptionTH"] as? String
        imageURL = (dic["imageURL"] as? String ?? "N/A")
    }
    
}
