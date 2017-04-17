
import Foundation

class FacultyModel {
    
    var faculyId : Int
    var facultyName  : String
    var facultyAbb : String
    var imageURL :String
    
    init() {
        faculyId = 99999
        facultyName = "N/A"
        facultyAbb = "N/A"
        imageURL = "N/A"
    }
    
    init(dic : AnyObject) {
        faculyId = dic["facultyID"] as! Int
        facultyName = dic["facultyName"] as! String
        facultyAbb = dic["facultyAbb"] as! String
        imageURL = (dic["imageURL"] as? String ?? "N/A")
    }
    
}
