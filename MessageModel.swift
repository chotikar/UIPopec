
import Foundation

class MessageModel {
    
//    UserID: 10005,
//    FacultyID: 5,
//    FacultyName: "Martin De Tours School of Management and Economics",
//    ProgramID: 34,
//    ProgramName: "Real Estate",
//    RoomName: "10005534",
//    Date: "10/04/2017",
//    Time: "10:22pm.",
//    Message: null,
//    Active: true
    
    var facName : String!
    var facId : Int64!
    var programId : Int64!
    var programName : String!
    var date : String!
    var time : String!
    var roomCode : String!
    var mess : String!
     
    init(dic : AnyObject){
        self.facName = dic["FacultyName"] as? String
        self.facId = dic["FacultyID"] as? Int64
        self.programId = dic["ProgramID"] as? Int64
       self.programName = dic["ProgramName"] as? String
       self.date = dic["Date"] as? String
        self.time = dic["Time"] as? String
       self.mess = dic["Message"] as? String ?? ""
        self.roomCode = dic["RoomName"] as? String
    }

    
}
