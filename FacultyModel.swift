
import Foundation

class FacultyModel {
    
    var faculyId : Int
    var facultyName  : String
    var facultyKeyword : String
    var imageURL :String
    
    init() {
        faculyId = 99999
        facultyName = "N/A"
        facultyKeyword = "N/A"
        imageURL = ""
    }
    
    init(dic : AnyObject) {
        faculyId = dic["facultyID"] as! Int
        facultyName = dic["facultyName"] as! String
        facultyKeyword = dic["facultyKeyword"] as! String
        imageURL = (dic["imageURL"] as? String ?? "")
    }
    
}
