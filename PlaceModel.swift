
import Foundation
class PlaceModel {
 
    var placeId : Int
    var placeName : String
    var placeDescriptionTh  : String
    var placeDescriptionEn : String
    var longitude : String
    var latitude :String
    
    init() {
        placeId = 99999
        placeName = "N/A"
        placeDescriptionEn = "N/A"
        placeDescriptionTh = "N/A"
        latitude = "N/A"
        longitude = "N/A"
    }
    
    init(dic : AnyObject) {
        placeId = dic[""] as! Int
        placeName = dic[""] as! String
        placeDescriptionEn = dic[""] as! String
        placeDescriptionTh = dic[""] as! String
        latitude = dic[""] as! String
        longitude = dic[""] as! String
//    imageURL = (dic["imageURL"] as? String ?? "N/A")
    }

    
}
