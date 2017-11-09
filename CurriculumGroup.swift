
import Foundation

class CurriculumGroup {

    
    var academicYear : String!
    var facultyID : Int!
    var programID : Int!
    var generalCredit : Int!
    var courseCredit : Int!
    var electiveCredit :Int!
    var groupTypeCourse = [CourseGroup]()
    
    init() {
        academicYear = "N/A"
        facultyID = 999999999
        programID = 999999999
        generalCredit = 999999999
        courseCredit = 999999999
        electiveCredit = 9999999
    }
    
    init(dic : AnyObject) {
        academicYear = dic["AcademicYear"] as? String
        facultyID = dic["FacultyID"] as? Int
        programID = dic["ProgramID"] as? Int
        generalCredit = dic["GeneralCredit"] as? Int
        courseCredit = dic["CourseCredit"] as? Int
        electiveCredit = dic["ElectiveCredit"] as? Int
        groupTypeCourse.append(CourseGroup(titleName: "Language Course", dic: (dic["LanguageCourse"] as? [[String: AnyObject]])!))
        groupTypeCourse.append(CourseGroup(titleName: "Humanities Course", dic: (dic["HumanitiesCourse"]as? [[String: AnyObject]])!))
        groupTypeCourse.append(CourseGroup(titleName: "Social Course", dic: (dic["SocialCourse"] as? [[String: AnyObject]])!))
        groupTypeCourse.append(CourseGroup(titleName: "SciMath Course", dic: (dic["SciMathCourse"] as? [[String: AnyObject]])!))
        groupTypeCourse.append(CourseGroup(titleName: "Basic Core Course", dic: (dic["BasicCoreCourse"] as? [[String: AnyObject]])!))
        groupTypeCourse.append(CourseGroup(titleName: "Major Require Course", dic: (dic["MajorRequireCourse"] as? [[String: AnyObject]])!))
        groupTypeCourse.append(CourseGroup(titleName: "Major Elective Course", dic: (dic["MajorElectiveCourse"] as? [[String: AnyObject]])!))
        groupTypeCourse.append(CourseGroup(titleName: "Minor Require Course", dic: (dic["MinorRequireCourse"] as? [[String: AnyObject]])!))
        groupTypeCourse.append(CourseGroup(titleName: "Minor Elective Course", dic: (dic["MinorElectiveCourse"] as? [[String: AnyObject]])!))
        groupTypeCourse.append(CourseGroup(titleName: "Free Elective Course", dic: (dic["FreeElectiveCourse"] as? [[String: AnyObject]])!))
    }
}

class CourseGroup {
    
    var title : String!
    var subgroup = [CurriculumSubGroup]()
    
    init(){
        title = "N/A"
    }
    init(titleName: String, dic : [[String: AnyObject]]){
        title = titleName
        for i in dic {
            subgroup.append(CurriculumSubGroup(dic:i as AnyObject))
        }
    }
}
class CurriculumSubGroup {
    var courseCode : String!
    var courseName : String!
    var credit : Int!
    
    init() {
        courseCode = "N/A"
        courseName = "N/A"
        credit = 9999999
    }
    
    init(dic : AnyObject) {
        courseCode =  dic["CourseCode"] as? String
        courseName =  dic["CourseName"] as? String
        credit =  dic["Credit"] as? Int
    }
}
