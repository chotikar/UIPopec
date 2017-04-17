
import Foundation

class WebService {
    
    static let domainName:String = "http://www.supanattoy.com:89/"
    
    //Error Domain=NSCocoaErrorDomain Code=3840 "JSON text did not start with array or object and option to allow fragments not set." 
    //error: unexpectedly found nil while unwrapping an Optional value
    // WRONG URL OR
    
    //*****Faculty*****
    ///////////////////
    
    //tskyonline.com:89/Faculty/getFacultyList
    static func GetFacultyWS(language : String ,completion:@escaping (_ responseData:[FacultyModel],_ errorMessage:NSError?)->Void)
    {
        var facultyList : [FacultyModel] = []
        let url = NSURL(string: "\(domainName)Faculty/GetFacultyList?language=\(language)")
        print(url)
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
    
    //tskyonline.com:89/Faculty/getFacultyDetail?facultyID=5
    static func GetMajorWS(facultyId : Int, language : String,completion:@escaping (_ responseData:FacultyMajorModel,_ errorMessage:NSError?)->Void)
    {
        var facultyMajor = FacultyMajorModel()
        let url = NSURL(string: "\(domainName)Faculty/GetFacultyDetail?facultyID=\(facultyId)&language=\(language)")
        print(url)
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
    
    //tskyonline.com:89/Faculty/getDepartmentDetail?facultyID=5&departmentID=36
    static func GetMajorDetailWS(facultyId : Int,departmentId : Int , language : String,completion:@escaping (_ responseData:MajorModel,_ errorMessage:NSError?)->Void)
    {
        var major = MajorModel()
        let url = NSURL(string: "\(domainName)Faculty/GetDepartmentDetail?facultyID=\(facultyId)&departmentID=\(departmentId)&language=\(language)")
        print(url)
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
    static func GetNewsRequireWS(lastNewsId : Int ,numberOfNews : Int ,completion:@escaping (_ responseData:[NewsModel],_ errorMessage:NSError?)->Void)
    {
        var NewsList : [NewsModel] = []
        let url = NSURL(string: "\(domainName)News/getNews?lastNewsId=\(lastNewsId)&numberOfNews=\(numberOfNews)")
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                if let validJson = jsonResult as? [[String : AnyObject ]]{
                    for i in validJson {
                        NewsList.append(NewsModel(dic: i as AnyObject))
                    }

                    completion(NewsList, error as NSError?)
                } else {
                    print("Error")
                }
                
            } catch let myJSONError {
                print("Error : ", myJSONError)
            }
        }
        task.resume()
    }
    
    static func GetContactRequireWS (completion:@escaping (_ responseData:[ContactModel],_ errorMessage:NSError?) -> Void) {
        
        var ContactList : [ContactModel] = []
        let url = NSURL(string: "\(domainName)Contact/GetAllContact")
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                
                if let validJson = jsonResult as? [[String:AnyObject]] {
                    for i in validJson {
                        ContactList.append(ContactModel(dic: i as AnyObject))
                    }
                    completion(ContactList, error as NSError?)
                } else {
                    print("Error")
                }
                
            } catch let myJSONError {
                print("Error : ", myJSONError)
            }
        }
        task.resume()
    }
    
    static func GetAllPlaceWS (completion:@escaping (_ responseData:[PlaceModel],_ errorMessage:NSError?) -> Void) {
        
        var PlaceList : [PlaceModel] = []
        let url = NSURL(string: "\(domainName)Location/GetAllLocation")
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                
                if let validJson = jsonResult as? [[String:AnyObject]] {
                    for i in validJson {
                        PlaceList.append(PlaceModel(dic: i as AnyObject))
                    }
                    completion(PlaceList, error as NSError?)
                } else {
                    print("Error")
                }
                
            } catch let myJSONError {
                print("Error : ", myJSONError)
            }
        }
        task.resume()
    }
    
    static func GetCalendarWS (completion:@escaping (_ responseData:[CalendarModel],_ errorMessage:NSError?) -> Void) {
        
        var CalendarEvent : [CalendarModel] = []
        let url = NSURL(string: "\(domainName)Calendar/GetCalendar?year=2017&language=E")
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                
                if let validJson = jsonResult as? [[String:AnyObject]] {
                    for i in validJson {
                        CalendarEvent.append(CalendarModel(dic: i as AnyObject))
                    }
                    completion(CalendarEvent, error as NSError?)
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

