
import Foundation

class ChatLogModel {
    
    var sendby : Int!
    var userId : Int
    var staffId : Int
    var mess :  String!
    var date :  String!
    var  time :  String!
    //var DeviceID: String!

//    var name : String!
//    var text : String!
//    
//    init() {
//        self.name = ""
//        self.text = ""
//    }
//    
//    init(name : String, text : String){
//        self.name = name
//        self.text = text
//        
//    }
    
    init (dic : AnyObject) {
        self.sendby = dic["Sendby"] as! Int
        self.userId = dic["UserID"] as! Int
        self.staffId = dic["StaffID"] as! Int
        self.mess = dic["Message"] as! String
        self.date = dic["Date"] as! String
        self.time = dic["Time"] as! String
        
    }
    
}

//class ChatLog {
//
//    var receiverId : String!
//    var senderId : String!
//    var text: String!
//    var time: String!
//
//    init() {
//        self.receiverId = ""
//        self.senderId = ""
//        self.text = ""
//        self.time = ""
//    }
//
//    init (dic : AnyObject) {
//        self.receiverId = dic["ReceiverID"] as! String
//        self.senderId = dic["SenderID"] as! String
//        self.text = dic["Message"] as! String
//        self.time = dic["Time"] as! String
//    }
//
//}
