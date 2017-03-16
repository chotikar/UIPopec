
import Foundation

class ChatLog {
    
    var receiverId : String!
    var senderId : String!
    var text: String!
    var time: String!
    
    init() {
        self.receiverId = ""
        self.senderId = ""
        self.text = ""
        self.time = ""
    }
    
    init (dic : AnyObject) {
        self.receiverId = dic["ReceiverID"] as! String
        self.senderId = dic["SenderID"] as! String
        self.text = dic["Message"] as! String
        self.time = dic["Time"] as! String
    }
    
}
