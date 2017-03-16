
import Foundation
import CoreData

class UserLogInDetail {
    
    var email :String!
    var facebookId  :String!
    var facebookName :String!
    var facebookAccessToken :String!
    var udid:String!
    
    init() {
        self.email = ""
        self.facebookId = ""
        self.facebookName = ""
        self.facebookAccessToken = ""
        self.udid = ""
    }
    
    init(obj : NSManagedObject){
        self.email = obj.value(forKey: "email") as? String
        self.facebookId = obj.value(forKey: "facebook_id") as? String
        self.facebookName = obj.value(forKey: "facebook_name") as? String
        self.facebookAccessToken = obj.value(forKey: "facebook_access_token") as? String
        self.udid = obj.value(forKey: "udid_device") as? String
    }
    
    init(dic: AnyObject , token : String,UDID : String) {
        self.email = dic["email"] as? String
        self.facebookId = dic["id"] as? String
        self.facebookName = dic["first_name"] as? String
        self.facebookAccessToken = token
        self.udid = UDID
    }
    
}
