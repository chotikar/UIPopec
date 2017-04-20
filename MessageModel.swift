
import Foundation

class MessageModel {
    
    var facName : String!
    var facAbb : String!
    var roomCode : String!
    var message : String!
    var time : String!
    
    init(){
        self.facName = "N/A"
        self.facAbb = "N/A"
        self.roomCode = "N/A"
        self.message = "N/A"
        self.time = "N/A"
    }
    
    init(dic : AnyObject){
        self.facName = dic["keyword"] as? String
        self.facAbb = dic["keyword"] as? String
        self.roomCode = dic["keyword"] as? String
        self.message = dic["keyword"] as? String
        self.time = dic["keyword"] as? String
    }

    
}
