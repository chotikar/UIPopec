
import Foundation
import CoreData

class UserLogInDetail {
    
    var userId : String!
    var email : String!
    var facebookId : String!
    var facebookName : String!
    var facebookAccessToken : String!
    var udid : String!
    var username : String!
    var password : String!
    var type : Int16!
    
    init() {
        self.userId = "N/A"
        self.email = "N/A"
        self.facebookId = "N/A"
        self.facebookName = "N/A"
        self.facebookAccessToken = "N/A"
        self.udid = "N/A"
        self.username = "N/A"
        self.password = "N/A"
        self.type = 0
    }
    
    init(obj : [NSManagedObject], typeobj : Int16) {
        self.userId = obj.first?.value(forKey: "userId") as? String ?? "N/A"
        self.email = obj.first?.value(forKey: "email") as? String ?? "N/A"
        self.facebookId = obj.first?.value(forKey: "facebook_id") as? String ?? "N/A"
        self.facebookName = obj.first?.value(forKey: "facebook_name") as? String ?? "N/A"
        self.facebookAccessToken = obj.first?.value(forKey: "facebook_access_token") as? String ?? "N/A"
        self.udid = obj.first?.value(forKey: "udid_device") as? String ?? "N/A"
        self.username = obj.first?.value(forKey: "username") as? String ?? "N/A"
        self.password = obj.first?.value(forKey: "password") as? String ?? "N/A"
        self.type = typeobj
    }
    
//    UserID: 5,
//    Username: "N/A",
//    Password: "N/A",
//    Email: "N/A",
//    FacebookName: "kornkamol",
//    FacebookID: "1234567890",
//    AccessToken: "0987654321",
//    ImageURL: "https://image.flaticon.com/icons/svg/201/201818.svg"
    
    init(dic: AnyObject, typews : Int16, udid : String) {
        self.userId = dic["UserID"] as? String ?? "N/A"
        self.email = dic["Email"] as? String ?? "N/A"
        self.facebookId = dic["FacebookID"] as? String ?? "N/A"
        self.facebookName = dic["FacebookName"] as? String ?? "N/A"
        self.facebookAccessToken = dic["AccessToken"] as? String ?? "N/A"
        self.username = dic["Username"] as? String ?? "N/A"
        self.password = dic["Password"] as? String ?? "N/A"
        self.type = typews
        self.udid = udid
    }
    
}
