
import Foundation

class MessageModel {
    
//    UserID: 10005,
//    FacultyID: 5,
//    FacultyName: "Martin De Tours School of Management and Economics",
//    ProgramID: 34,
//    ProgramName: "Real Estate",
//    ProgramAbb: "REM",
//    RoomName: "10005534",
//    DateOrTime: "9:44 PM",
//    DateTime: "2017-04-27T21:44:32.4",
//    Message: "Kk",
//    
    var facName : String!
    var facId : Int64!
    var programId : Int64!
    var programName : String!
    var programAbb : String!
    var time : String!
    var roomCode : String!
    var mess : String!
     
    init(dic : AnyObject){
        self.facName = dic["FacultyName"] as? String
        self.facId = dic["FacultyID"] as? Int64
        self.programId = dic["ProgramID"] as? Int64
       self.programName = dic["ProgramName"] as? String
        self.programAbb = dic["ProgramAbb"] as? String
        self.time = dic["DateOrTime"] as? String
       self.mess = dic["Message"] as? String ?? ""
        self.roomCode = dic["RoomName"] as? String
    }

    init(uid : Int64 ,fn : String ,fid : Int ,pn : String , pid : Int){
        self.facName = fn
        self.facId = Int64(fid)
        self.programId = Int64(pid)
        self.programName = pn
        self.time = "00:00:00"
        self.mess = ""
        self.roomCode = "\(uid)\(fid)\(pid)"
    }
    
}
