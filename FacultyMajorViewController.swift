
import UIKit
import Foundation

class FacultyMajorViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    var facultyCode : Int!
    var facultyMajorInformation = FacultyMajorModel()
    var majorCellItemId = "MajorCellItem"
    let cm = CalculateMutual.self
    
    @IBOutlet var majorTableView : UITableView!
    let scoll : UIScrollView = {
        var sc = UIScrollView()
        sc.frame = CGRect(x: 0, y: 0, width: scWid, height: scHei)
        return sc
    }()
    var mainImage : UIImageView!
    var facTitle : UILabel!
    var facSubtitle : UILabel!
    var location : UIView!
    var descrip : UITextView!
    var logo : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadTableViewInFacMajor()
        self.majorTableView.delegate = self
        self.majorTableView.dataSource = self
        self.view.addSubview(self.scoll)
        self.scoll.addSubview(majorTableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadTableViewInFacMajor() {
        WebService.GetMajorWS(facultyId: self.facultyCode){ (responseData: FacultyMajorModel, nil) in
            DispatchQueue.main.async( execute: {
                self.facultyMajorInformation = responseData
                self.majorTableView.reloadData()
                self.reloadInputViews()
                self.setTableViewSize(majorNum: self.facultyMajorInformation.marjorList.count, content: self.drawNewsInformation())
            })
        }
    }
    
    func drawNewsInformation() -> CGFloat {
        var hei : CGFloat
        mainImage = UIImageView(frame: CGRect(x: 0, y: scWid * 0.05, width: scWid, height: scWid*0.7))
        mainImage.backgroundColor = UIColor.yellow
        self.scoll.addSubview(mainImage)
         var texthei = cm.calculateHeiFromString(text: self.facultyMajorInformation.facultyAbb,fontsize: UIFont.boldSystemFont(ofSize: 20), tbWid :scWid * 0.9 ).height + 5
        
        facTitle = UILabel(frame: CGRect(x: scWid * 0.05, y: scWid * 0.8, width: scWid * 0.9, height: texthei))
        facTitle.text = self.facultyMajorInformation.facultyAbb
        facTitle.font = UIFont.boldSystemFont(ofSize: 20)
        self.scoll.addSubview(facTitle)
        hei = facTitle.frame.origin.y + facTitle.frame.height
        texthei = cm.calculateHeiFromString(text:  self.facultyMajorInformation.facultyNameEn,fontsize: UIFont.systemFont(ofSize: 14), tbWid : scWid*0.86).height
        
        facSubtitle = UILabel(frame: CGRect(x: scWid * 0.07, y:  hei, width: scWid*0.86, height: texthei))
        facSubtitle.text = self.facultyMajorInformation.facultyNameEn
        facSubtitle.font = UIFont.systemFont(ofSize: 15)
        self.scoll.addSubview(facSubtitle)
        hei = facSubtitle.frame.height + facSubtitle.frame.origin.y
//        texthei = estimateFrameForText(text:  "N/A",fontsize: UIFont.systemFont(ofSize: 13)).height+10
        
//        location = UIView(frame: CGRect(x: scWid * 0.37, y: hei, width: scWid*0.54, height: texthei))
//        self.scoll.addSubview(location)
//        let loIcon =  UIImageView(frame: CGRect(x: 0, y: 0, width: texthei, height: texthei))
//        loIcon.image = UIImage(named: "locationnoGray")
//        self.location.addSubview(loIcon)
//        let loDef =  UILabel(frame: CGRect(x: texthei + 10, y: 0, width: location.bounds.width - (texthei+10), height: texthei))
//        loDef.font = UIFont.systemFont(ofSize: 13)
//        loDef.text = "N/A"
//        self.location.addSubview(loDef)
//        hei = location.frame.height + location.frame.origin.y+20
        texthei = cm.calculateHeiFromString(text:  self.facultyMajorInformation.descriptionTh,fontsize: UIFont.systemFont(ofSize: 12), tbWid : scWid * 0.86).height + 40
        
        descrip  = UITextView(frame: CGRect(x: scWid * 0.07, y: hei, width: scWid*0.86, height: texthei))
        descrip.font = UIFont.systemFont(ofSize: 12)
        descrip.textAlignment = .center
        descrip.text = self.facultyMajorInformation.descriptionTh
        self.scoll.addSubview(descrip)
        hei = descrip.frame.height + descrip.frame.origin.y
        
        logo = UIImageView(frame: CGRect(x: scWid*0.07, y: hei, width: scWid*0.3, height: scWid*0.3))
        logo.image = UIImage(named: "vme_logo")
        self.scoll.addSubview(logo)
        
        return hei + scWid*0.15
    }

    func setTableViewSize(majorNum : Int, content : CGFloat){
        self.majorTableView.frame = CGRect(x: 0, y: content, width: scWid, height: (scWid*0.7) * CGFloat(majorNum))
        self.scoll.contentSize = CGSize(width: scWid, height: content + self.majorTableView.frame.height)
    }
    
    // Major Tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return facultyMajorInformation.marjorList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: majorCellItemId, for: indexPath) as! MajorCell
        cell.selectionStyle = .none
        if indexPath.row%2 == 0 {
           cell.bgMajor.backgroundColor = UIColor.brown
            cell.cgframe = CGRect(x: scWid*0.3, y: cell.frame.height*0.7, width: scWid*0.7, height: cell.frame.height*0.2)
        }else{
            cell.bgMajor.backgroundColor = UIColor.yellow
            cell.cgframe = CGRect(x: 0, y: cell.frame.height*0.7, width: scWid*0.7, height: cell.frame.height*0.2)
        }
        cell.name.text = self.facultyMajorInformation.marjorList[indexPath.row].departmentNameEn
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MajorLayout") as! MajorViewController
       vc.facultyFullName = self.facultyMajorInformation.facultyNameEn
        vc.majorInformation = self.facultyMajorInformation.marjorList[indexPath.row]
        self.present(vc, animated: true, completion: nil)
        //self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return scWid*0.7
    }
}

class  MajorCell : UITableViewCell{
    
    @IBOutlet var bgMajor : UIImageView!
    @IBOutlet var bgName : UIView!
    @IBOutlet var name : UILabel!
    var cgframe : CGRect!
    
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
        bgName.frame = cgframe
        bgName.backgroundColor = UIColor.white
        bgName.alpha = 0.7
        name.frame = cgframe
        name.textAlignment = .center
        name.font = UIFont.boldSystemFont(ofSize: 20)
        name.textColor = UIColor.darkGray
    }
    
}
