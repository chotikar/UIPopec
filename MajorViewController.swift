
import UIKit
import Foundation

class MajorViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    var facultyCode : Int!
    var facultyMajorInformation = FacultyMajorModel()
    var majorCellItemId = "MajorCellItem"
    @IBOutlet var majorTableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.majorTableView.delegate = self
        self.majorTableView.dataSource = self
        self.view.addSubview(majorTableView)
        self.majorTableView.backgroundColor = UIColor.brown
       setTableViewSize(majorNum: 2)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadTableViewInFacMajor() {
        WebService.GetMajorWS(facultyId: self.facultyCode){ (responseData: FacultyMajorModel, nil) in
            DispatchQueue.main.async( execute: {
                self.facultyMajorInformation = responseData
               // self.tableView.reloadData()
            })
        }
    }

    func setTableViewSize(majorNum:Int){
        self.majorTableView.frame = CGRect(x: 0, y: 0, width: scWid, height: (scWid*0.8) * 2.0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: majorCellItemId, for: indexPath) as! MajorCell
        cell.selectionStyle = .none
        if indexPath.row%2 == 0 {
           cell.bgMajor.backgroundColor = UIColor.red
        }else{
            cell.bgMajor.backgroundColor = UIColor.yellow
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return scWid*0.7
    }
}

class  MajorCell : UITableViewCell{
    
    @IBOutlet var bgMajor : UIImageView!
    @IBOutlet var bgName : UIView!
    @IBOutlet var name : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(bgMajor)
        self.contentView.addSubview(bgName)
        self.contentView.addSubview(name)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bgMajor.frame = CGRect(x: 0, y: 0, width: scWid, height: scWid*0.7)
        
    }
    
}
