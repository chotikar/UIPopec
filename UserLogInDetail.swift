
import Foundation
import CoreData

class UserLogInDetail {
    var byFacebook : Int16
    var userId : Int64!
    var email : String!
    var facebookId : String!
    var facebookName : String!
    var facebookAccessToken : String!
    var udid : String!
    var username : String!
    var password : String!
    var result : ResultModle!
    
    init() {
        self.byFacebook = 0
        self.userId = 0
        self.email = "N/A"
        self.facebookId = "N/A"
        self.facebookName = "N/A"
        self.facebookAccessToken = "N/A"
        self.udid = "N/A"
        self.username = "N/A"
        self.password = "N/A"
        self.result = ResultModle()
    }
    
    init(obj : [NSManagedObject]) {
        self.byFacebook = (obj.first?.value(forKey: "byFacebook") as? Int16)! ?? 0
        self.userId = obj.first?.value(forKey: "userId") as? Int64 ?? 0
        self.email = obj.first?.value(forKey: "email") as? String ?? "N/A"
        self.facebookId = obj.first?.value(forKey: "facebook_id") as? String ?? "N/A"
        self.facebookName = obj.first?.value(forKey: "facebook_name") as? String  ?? "N/A"
        self.facebookAccessToken = obj.first?.value(forKey: "facebook_access_token") as? String ?? "N/A"
        self.udid = obj.first?.value(forKey: "udid_device") as? String ?? "N/A"
        self.username = obj.first?.value(forKey: "username") as? String ?? "N/A"
        self.password = obj.first?.value(forKey: "password") as? String ?? "N/A"
        self.result = ResultModle()
    }
    
//    UserID: 5,
//    Username: "N/A",
//    Password: "N/A",
//    Email: "N/A",
//    FacebookName: "kornkamol",
//    FacebookID: "1234567890",
//    AccessToken: "0987654321",
//    ImageURL: "https://image.flaticon.com/icons/svg/201/201818.svg"
    
    init(dic: AnyObject, udid : String , byfac : Int16) {
//        print(dic["result"])
        self.userId = dic["UserID"] as? Int64
        self.email = dic["Email"] as? String
        self.facebookId = dic["FacebookID"] as? String
        self.facebookName = dic["FacebookName"] as? String
        self.facebookAccessToken = dic["AccessToken"] as? String
        self.username = dic["Username"] as? String
        self.password = dic["Password"] as? String 
        self.udid = udid
        self.byFacebook = byfac
        if dic["result"] != nil {
            self.result = ResultModle(dic: dic["result"] as AnyObject)
        }else{
            self.result = ResultModle()
        }
    }
}
