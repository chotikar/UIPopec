
import Foundation

class NewsModel {
    
    var newsId : Int!
    var topic : String!
    var typeId : Int!
    var typeName : String!
    var description : String!
    var imageURL : String!
    
    init() {
        newsId = 999999999
        topic = "N/A"
        typeId = 999999999
        typeName = "N/A"
        description = "N/A"
        imageURL = "N/A"
        
    }
    
    init(dic : AnyObject) {
        
        newsId = dic["NewsID"] as? Int
        topic = dic["Topic"] as? String
        typeId = dic["TypeID"] as? Int
        typeName = dic["Type"] as? String
        description = dic["Description"] as? String
        imageURL = (dic["imageURL"] as? String ?? "N/A")
    }
    
}
