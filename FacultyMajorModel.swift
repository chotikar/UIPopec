
import Foundation

class FacultyMajorModel {
    var faculyId : Int!
    var facultyName : String!
    var facultyAbb : String!
    var imageURL :String!
    var description: String!
    var facebook: String!
    var webpage: String!
    var email: String!
    var phone: String!
    var marjorList = [MajorModel]()
  //  var location:
    init() {
        faculyId = 99999
        facultyName = "N/A"
        facultyAbb = "N/A"
        imageURL = ""
        description = "N/A"
        facebook = "N/A"
        webpage = "N/A"
        email = "N/A"
        phone = "N/A"
    }
    
    init(dic : AnyObject) {
        faculyId = dic["facultyID"] as! Int
        facultyName = dic["facultyName"] as! String
        facultyAbb = dic["facultyAbb"] as! String
        imageURL = (dic["imageURL"] as? String ?? "")
        description = (dic["description"] as? String ?? "N/A")
        facebook = (dic["facebook"] as? String ?? "N/A")
        webpage = (dic["webpage"] as? String ?? "N/A")
        email = (dic["email"] as? String ?? "N/A")
        phone = (dic["phone"] as? String ?? "N/A")
        
        let mList = dic["departmentlist"] as? [[String: AnyObject]]
        for i in mList! {
            marjorList.append(MajorModel(dic:i as AnyObject))
        }
    }
}

class MajorModel {
    var departmentId : Int!
    var departmentEnName: String!
    var departmentThName: String!
    var degree: Int!
    var degreeName : String!
    var departmentAbb: String!
    var imageURL: String!
    var description: String!
    var departmentName: String!
    
    init(){
        departmentId = 99999
        departmentEnName = "N/A"
        departmentThName = "N/A"
        degree = 99999
        degreeName = "N/A"
        departmentAbb = "N/A"
        imageURL = ""
        description = "N/A"
        departmentName = ""
    }
    
    init(dic :AnyObject) {
        departmentId = dic["departmentID"]  as! Int
        departmentEnName = dic["departmentNameEn"]  as? String ?? ""
        departmentThName = dic["departmentNameTh"]  as? String ?? ""
        degree = dic["degree"] as! Int
        degreeName = (dic["degreeName"] as? String ?? "N/A")
        departmentAbb = (dic["departmentAbb"] as? String ?? "N/A")
        imageURL = (dic["imageURL"] as? String ?? "")
        description = (dic["description"] as? String ?? "N/A")
        departmentName = dic["departmentName"]   as? String ?? ""
    }
}
