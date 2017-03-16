
import Foundation

class WebService {
    static let domainName:String = "http://tskyonline.com:89/"
    
    static func GetFacultyWS(completion:@escaping (_ responseData:[FacultyModel],_ errorMessage:NSError?)->Void)
    {
        var facultyList : [FacultyModel] = []
        let url = NSURL(string: "\(domainName)Faculty/getFacultyList")
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                
                if let validJson = jsonResult as? [[String:AnyObject]] {
                    for i in validJson {
                       facultyList.append(FacultyModel(dic: i as AnyObject))
                        
                    }
                    completion(facultyList, error as NSError?)
                } else {
                    print("Error")
                }
                
            } catch let myJSONError {
                print("Error : ", myJSONError)
            }
        }
        task.resume()
    }
    
    
    static func GetMajorWS(facultyId : Int ,completion:@escaping (_ responseData:FacultyMajorModel,_ errorMessage:NSError?)->Void)
    {
        var facultyMajor = FacultyMajorModel()
        let url = NSURL(string: "\(domainName)Faculty/getFacultyDetail?facultyID=\(facultyId)")
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                if let validJson = jsonResult as? AnyObject {
                    
                    facultyMajor =  FacultyMajorModel(dic: validJson)
                    completion(facultyMajor, error as NSError?)
                } else {
                    print("Error")
                }
                
            } catch let myJSONError {
                print("Error : ", myJSONError)
            }
        }
        task.resume()    }

}

