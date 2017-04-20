
import Foundation

class WebService {
    
    static let domainName:String = "http://www.supanattoy.com:89/"
    
    //Error Domain=NSCocoaErrorDomain Code=3840 "JSON text did not start with array or object and option to allow fragments not set."
    //error: unexpectedly found nil while unwrapping an Optional value
    // WRONG URL OR
    
 
    
    // MARK: FACULTY
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
                    print(major.departmentName)
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
    
    
    // MARK: NEWS
    static func GetNewsRequireWS(lastNewsId : Int ,numberOfNews : Int ,lang :String,completion:@escaping (_ responseData:[NewsModel],_ errorMessage:NSError?)->Void)
    {
        var NewsList : [NewsModel] = []
        let url = NSURL(string: "\(domainName)News/GetNews?lastNewsId=\(lastNewsId)&numberOfNews=\(numberOfNews)&language=\(lang)")
        print(url)
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
    
    
    // MARK: CONTACT
    static func GetContactRequireWS (lang:String,completion:@escaping (_ responseData:[ContactModel],_ errorMessage:NSError?) -> Void) {
        
        var ContactList : [ContactModel] = []
        let url = NSURL(string: "\(domainName)Contact/GetAllContact?language=\(lang)")
        print(url)
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
    
    
    // MARK: LOCATION
    static func GetAllPlaceWS (lang :String,completion:@escaping (_ responseData:[PlaceModel],_ errorMessage:NSError?) -> Void) {
        
        var PlaceList : [PlaceModel] = []
        let url = NSURL(string: "\(domainName)Location/GetAllLocation?language=\(lang)")
        print(url)
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
    
    
    // MARK: CALENDAR
    static func GetCalendarWS (completion:@escaping (_ responseData:[CalendarModel],_ errorMessage:NSError?) -> Void) {
        
        var CalendarEvent : [CalendarModel] = []
        let url = NSURL(string: "\(domainName)Calendar/GetCalendar?year=2017&language=E")
        print(url)
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
    
    
    // MARK: APPLICATION
    static func ApplyWS (Semester: Int,Year: Int , isThai: Bool, Citizen: String,titlename: String,
                         fname: String, lname: String,gender: String, national: String, birthdate: String, mobile: String,
                         email: String, highsch: String, degree: Int, facultyID: Int, programID: Int,
                         ielts: Int, toefl_ibt: Int, toefl_p: Int, sat_math: Int, sat_writing: Int) ->Void {
        
        var urlstring = "\(domainName)AppliedStudent/ApplyNewStudent?year=\(Year)&semester=\(Semester) &isThai=\(isThai)&IDnumber=\(Citizen)&profile=\(titlename);\(fname);\(lname);\(gender);\(national);\(birthdate);\(mobile);\(email);\(highsch)&degree=\(degree)&facultyID=\(facultyID)&programID=\(programID)&scorelist=\(ielts);\(toefl_ibt);\(toefl_p);\(sat_math);\(sat_writing)"
        
        
        urlstring = urlstring.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!
        print ("-------\(urlstring)")
            
        let requestURL: NSURL = NSURL(string: urlstring)!
        let request = URLRequest(url: requestURL as URL)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            if error == nil {
                let stringData = String(data: data!, encoding: .utf8)
                print ("**\(String(describing: stringData))*")
                
            }
        }
        task.resume()
    }
    

    static func GetKeyWordRequireWS(lang : String ,completion:@escaping (_ responseData:[KeyWordModel],_ errorMessage:NSError?)->Void)
    {
        var KeyWordList : [KeyWordModel] = []
        let url = NSURL(string: "\(domainName)Suggestion/GetKeywordList?language=\(lang)")
        print(url)
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                if let validJson = jsonResult as? [[String : AnyObject ]]{
                    for i in validJson {
                        KeyWordList.append(KeyWordModel(dic: i as AnyObject))
                    }
                    
                    completion(KeyWordList, error as NSError?)
                } else {
                    print("Error")
                }
                
            } catch let myJSONError {
                print("Error : ", myJSONError)
            }
        }
        task.resume()
    }
    
    static func GetSuggestionFacRequireWS(sugCode:String,lang : String ,completion:@escaping (_ responseData:[FacSuggestionModel],_ errorMessage:NSError?)->Void)
    {
        var facSugList : [FacSuggestionModel] = []
        let url = NSURL(string: "\(domainName)Suggestion/GetSuggestionProgram?keywordlist=\(sugCode)&language=\(lang)")

        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                if let validJson = jsonResult as? [[String : AnyObject ]]{
                    for i in validJson {
                       facSugList.append(FacSuggestionModel(dic: i as AnyObject))
                    }
                    
                    completion(facSugList, error as NSError?)
                } else {
                    print("Error")
                }
                
            } catch let myJSONError {
                print("Error : ", myJSONError)
            }
        }
        task.resume()
    }
    

    // MARK: LOGIN
    //http://www.supanattoy.com:89/Chat/SignInAndSignUp?byFacebook=1&userDetail=kornkamol;1234567890;0987654321&deviceID=0001&imageURL=N/A
    //FIXME: sign in
    static func sentLoginInformationWS(byfacebook : Int , userDetail : String , deviceId : String,imageUrl : String ,completion:@escaping (_ responseData:UserLogInDetail,_ errorMessage:NSError?)->Void)
    {
        var loginInformation : UserLogInDetail!
        let url = NSURL(string: "\(domainName) Chat/SignInAndSignUp?byFacebook=\(byfacebook)&userDetail=\(userDetail)&deviceID=\(deviceId)&imageURL=\(imageUrl)")
        print(url)
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                if let validJson = jsonResult as? [String : AnyObject ]{
                    if byfacebook == 0 {
                        loginInformation = UserLogInDetail(dic: validJson as AnyObject, typews: Int16(1), udid: deviceId)
                    }else{
                        loginInformation = UserLogInDetail(dic: validJson as AnyObject, typews: Int16(1), udid: deviceId)
                    }
                    
                    
                    completion(loginInformation, error as NSError?)
                } else {
                    print("Error")
                }
                
            } catch let myJSONError {
                print("Error : ", myJSONError)
            }
        }
        task.resume()
    }
    
    //FIXME: Signup
    
    //FIXME: Logout
    
    //FIXNE: Get Message List
    
    //FIXME: Get Chat Log
    
    //FIXME: Get Chat Log Previous

    // MARK: Chat
    // TODO: get message list
    // TODO: get chat befor list
    // FIXME: TEST
}
