
import Foundation

class ChatLogModel {
    
    var sendby : Int!
    var userId : Int
    var staffId : Int
    var mess :  String!
    var date :  String!
    var  time :  String!
    
    init (dic : AnyObject) {
        self.sendby = dic["Sendby"] as! Int
        self.userId = dic["UserID"] as! Int
        self.staffId = dic["StaffID"] as! Int
        self.mess = dic["Message"] as! String
        self.date = dic["Date"] as! String
        self.time = dic["Time"] as! String
    }
}
