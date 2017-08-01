
import Foundation

class MessageModel {

    var facName : String!
    var facId : Int64!
    var programId : Int64!
    var programNameEn : String!
    var programNameTh : String!
    var programAbb : String!
    var time : String!
    var roomCode : String!
    var mess : String!
     
    init(dic : AnyObject){
        self.facName = dic["FacultyName"] as? String
        self.facId = dic["FacultyID"] as? Int64
        self.programId = dic["ProgramID"] as? Int64
       self.programNameEn = dic["ProgramNameEn"] as? String
        self.programNameTh = dic["ProgramNameTh"] as? String
        self.programAbb = dic["ProgramAbb"] as? String
        self.time = dic["DateOrTime"] as? String
       self.mess = dic["Message"] as? String ?? ""
        self.roomCode = dic["RoomName"] as? String
    }

    init(uid : Int64 ,fn : String ,fid : Int ,pnEn : String,pnTh : String , pid : Int){
        self.facName = fn
        self.facId = Int64(fid)
        self.programId = Int64(pid)
        self.programNameEn = pnEn
        self.programNameTh = pnTh
        self.time = "00:00:00"
        self.mess = ""
        self.roomCode = "\(uid)\(fid)\(pid)"
    }
    
}
