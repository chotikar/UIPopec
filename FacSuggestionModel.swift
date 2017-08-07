

import Foundation
class FacSuggestionModel{
    var facultyID : Int!
    var facultyName :  String!
    var programID : Int!
    var programName : String!
    var programAbb: String!
    
        init (){
            self.facultyID = 99999
             self.facultyName =  "N/A"
             self.programID = 99999
             self.programName = "N/A"
            self.programAbb = "User_Shield"
    }
    
    init(dic: AnyObject) {
        self.facultyID = dic["FacultyID"] as? Int
        self.facultyName =  dic["FacultyName"] as? String
        self.programID = dic["ProgramID"] as? Int
        self.programName = dic["ProgramName"] as? String
        self.programAbb = dic["ProgramAbb"] as? String == "NP" ? "User_Shield" : dic["ProgramAbb"] as? String
    }
}
