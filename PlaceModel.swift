
import Foundation
class PlaceModel {
    
    var locationId: Int!
    var campusId: Int!
    var buildingName: String!
    var latitude: String!
    var longtitude: String!
    
    init() {
        locationId = 0
        campusId = 0
        buildingName = "N/A"
        latitude = ""
        longtitude = ""

    }
    
    init(dic : AnyObject) {
        locationId = dic["locationID"] as! Int
        campusId = dic["campusID"] as! Int
        buildingName = dic["buildingName"] as! String
        latitude = dic["latitude"] as! String
        longtitude = dic["longtitude"] as! String
//    imageURL = (dic["imageURL"] as? String ?? "N/A")
    }

    
}
