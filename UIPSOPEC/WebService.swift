
import Foundation

class WebService {
    
    static let domainName:String = "http://tskyonline.com:89/"
    
    //*****Faculty*****
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
        task.resume()
    }
    
    static func GetMajorDetailWS(facultyId : Int,departmentId : Int ,completion:@escaping (_ responseData:MajorModel,_ errorMessage:NSError?)->Void)
    {
        var major = MajorModel()
        let url = NSURL(string: "\(domainName)Faculty/getDepartmentDetail?facultyID=\(facultyId)&departmentID=\(departmentId)")
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                if let validJson = jsonResult as? AnyObject {
                    major =  MajorModel(dic: validJson)
                    completion(major, error as NSError?)
                } else {
                    print("Error")
                }
                
            } catch let myJSONError {
                print("Error : ", myJSONError)
            }
        }
        task.resume()
    }

    //*****News*****
    static func GetNewsRequireWS(lastNewsId : Int ,numberOfNews : Int ,completion:@escaping (_ responseData:NewsModel,_ errorMessage:NSError?)->Void)
    {
        var news = NewsModel()
        let url = NSURL(string: "\(domainName)News/getNews?lastNewsId=\(lastNewsId)&numberOfNews=\(numberOfNews)")
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                if let validJson = jsonResult as? AnyObject {
                    news =  NewsModel(dic: validJson)
                    completion(news, error as NSError?)
                } else {
                    print("Error")
                }
                
            } catch let myJSONError {
                print("Error : ", myJSONError)
            }
        }
        task.resume()
    }
    
}

