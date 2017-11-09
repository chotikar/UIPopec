
import UIKit

class CurriculumViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var curriculumTable = UITableView()
    let cellId = "curriculumCellId"
    let ws = WebService.self
    let fm = FunctionMutual.self
    var facultyId : String!
    var programId : String! = nil
    var programName : String!
    var curriculumList = CurriculumGroup()
    var programTitle = UILabel()
    var generalCredit = UILabel()
    var gCredit = UILabel()
    var courseCredit = UILabel()
    var cCredit = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        reloadCurriculum(facId: facultyId, proId: programId, semester: "2017")
        self.view.addSubview(programTitle)
        programTitle.translatesAutoresizingMaskIntoConstraints = false
        programTitle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        programTitle.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        programTitle.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        programTitle.heightAnchor.constraint(equalToConstant: 40).isActive = true
        programTitle.textAlignment = .center
        programTitle.font = fm.setFontSizeBold(fs: 20)
        programTitle.text = programName
        self.view.addSubview(generalCredit)
        generalCredit.translatesAutoresizingMaskIntoConstraints = false
        generalCredit.topAnchor.constraint(equalTo: programTitle.bottomAnchor).isActive = true
        generalCredit.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        generalCredit.heightAnchor.constraint(equalToConstant: 30).isActive = true
        generalCredit.widthAnchor.constraint(equalToConstant: scWid * 0.35).isActive = true
        generalCredit.textAlignment = .center
        generalCredit.font = fm.setFontSizeBold(fs: 15)
        generalCredit.text = "General Credit: "
        self.view.addSubview(gCredit)
        gCredit.translatesAutoresizingMaskIntoConstraints = false
        gCredit.topAnchor.constraint(equalTo: programTitle.bottomAnchor).isActive = true
        gCredit.leftAnchor.constraint(equalTo: generalCredit.rightAnchor).isActive = true
        gCredit.heightAnchor.constraint(equalToConstant: 30).isActive = true
        gCredit.widthAnchor.constraint(equalToConstant: scWid * 0.15).isActive = true
        gCredit.textAlignment = .center
        gCredit.font = fm.setFontSizeBold(fs: 15)
        gCredit.text = "9999"
        self.view.addSubview(courseCredit)
        courseCredit.translatesAutoresizingMaskIntoConstraints = false
        courseCredit.topAnchor.constraint(equalTo: programTitle.bottomAnchor).isActive = true
        courseCredit.leftAnchor.constraint(equalTo: gCredit.rightAnchor).isActive = true
        courseCredit.heightAnchor.constraint(equalToConstant: 30).isActive = true
        courseCredit.widthAnchor.constraint(equalToConstant: scWid * 0.35).isActive = true
        courseCredit.textAlignment = .center
        courseCredit.font = fm.setFontSizeBold(fs: 15)
        courseCredit.text = "Course Credit: "
        self.view.addSubview(cCredit)
        cCredit.translatesAutoresizingMaskIntoConstraints = false
        cCredit.topAnchor.constraint(equalTo: programTitle.bottomAnchor).isActive = true
        cCredit.leftAnchor.constraint(equalTo: courseCredit.rightAnchor).isActive = true
        cCredit.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cCredit.widthAnchor.constraint(equalToConstant: scWid * 0.15).isActive = true
        cCredit.textAlignment = .center
        cCredit.font = fm.setFontSizeBold(fs: 15)
        cCredit.text = "9999"
        self.view.addSubview(curriculumTable)
        curriculumTable.delegate = self
        curriculumTable.dataSource = self
        curriculumTable.translatesAutoresizingMaskIntoConstraints = false
        curriculumTable.topAnchor.constraint(equalTo: cCredit.bottomAnchor).isActive = true
        curriculumTable.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        curriculumTable.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        curriculumTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        curriculumTable.register(CurriculumSubCell.self, forCellReuseIdentifier: cellId)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return curriculumList.groupTypeCourse.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return drawTitle(title: curriculumList.groupTypeCourse[section].title, credit: "48")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return curriculumList.groupTypeCourse[section].subgroup.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CurriculumSubCell()
        let currInfo = curriculumList.groupTypeCourse[indexPath.section].subgroup[indexPath.row]
        cell.selectionStyle = .none
        cell.CourseSubTitle.text = currInfo.courseName
        cell.CourseCode.text = currInfo.courseCode
        cell.Credit.text = String(currInfo.credit)
        return cell
    }
    
    func reloadCurriculum(facId : String, proId:String, semester:String) {
        WebService.GetCurriculumDetailWS(facultyId: "7", departmentId: "17", semester: semester){ (responseData: CurriculumGroup, nil) in
            DispatchQueue.main.async( execute: {
                self.curriculumList = responseData
                self.curriculumTable.reloadData()
                self.reloadInputViews()
            })
        }
    }
    func drawTitle(title: String, credit: String)-> UIView{
        let CourseTitle : UILabel = {
            let ct = UILabel()
            ct.translatesAutoresizingMaskIntoConstraints = false
            ct.font = FunctionMutual.setFontSizeBold(fs: 15)
            ct.textColor = UIColor.white
            ct.text = title ?? "Course Title"
            return ct
        }()
        
        
        let TotalCredit : UILabel = {
            let tc = UILabel()
            tc.translatesAutoresizingMaskIntoConstraints = false
            tc.font = FunctionMutual.setFontSizeBold(fs: 13)
            tc.textColor = UIColor.white
            tc.text = credit ?? "9999"
            
            tc.textAlignment = .left
            return tc
        }()
        
        let CurriculumCell: UIView = {
            let curri = UIView()
            curri.addSubview(CourseTitle)
            curri.addSubview(TotalCredit)
            curri.backgroundColor = appColor
            TotalCredit.topAnchor.constraint(equalTo: curri.topAnchor, constant: 5).isActive = true
            TotalCredit.rightAnchor.constraint(equalTo: curri.rightAnchor, constant: -10).isActive = true
            TotalCredit.widthAnchor.constraint(equalToConstant: 40).isActive = true
            CourseTitle.topAnchor.constraint(equalTo: curri.topAnchor, constant: 5).isActive = true
            CourseTitle.leftAnchor.constraint(equalTo: curri.leftAnchor, constant: 5).isActive = true
            CourseTitle.rightAnchor.constraint(equalTo: TotalCredit.leftAnchor, constant: -5).isActive = true
            CourseTitle.bottomAnchor.constraint(equalTo: curri.bottomAnchor, constant: -5).isActive = true
            TotalCredit.leftAnchor.constraint(equalTo: CourseTitle.rightAnchor).isActive = true
            TotalCredit.bottomAnchor.constraint(equalTo: curri.bottomAnchor, constant: -5).isActive = true
            
            return curri
        }()
        return CurriculumCell
    }
}
