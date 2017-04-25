
import UIKit
import Foundation

class FacultyMajorViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    var facultyCode : Int!
    var facultyMajorInformation = FacultyMajorModel()
    var majorCellItemId = "MajorCellItem"
    let fm = FunctionMutual.self
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
    var activityiIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startIndicator()
        reloadTableViewInFacMajor(facId: self.facultyCode,lang: CRUDSettingValue.GetUserSetting())
        self.majorTableView.delegate = self
        self.majorTableView.dataSource = self
        self.view.addSubview(self.scoll)
        self.scoll.addSubview(majorTableView)
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadTableViewInFacMajor(facId : Int,lang:String) {
        WebService.GetMajorWS(facultyId: facId,language: lang){ (responseData: FacultyMajorModel, nil) in
            DispatchQueue.main.async( execute: {
                self.facultyMajorInformation = responseData
                self.majorTableView.reloadData()
                self.reloadInputViews()
                self.setTableViewSize(majorNum: self.facultyMajorInformation.marjorList.count, content: self.drawNewsInformation())
                self.stopIndicator()
            })
        }
    }
    
    func drawNewsInformation() -> CGFloat {
        var hei : CGFloat
        mainImage = UIImageView(frame: CGRect(x: 0, y: 64, width: scWid, height: scWid*0.7))
        if self.facultyMajorInformation.imageURL == "" {
            mainImage.image = UIImage(named:"abacImg")
        }else{
            mainImage.loadImageUsingCacheWithUrlString(urlStr: self.facultyMajorInformation.imageURL)
        }
        self.scoll.addSubview(mainImage)
        var texthei = fm.calculateHeiFromString(text: self.facultyMajorInformation.facultyAbb,fontsize: fm.setFontSizeBold(fs: 18), tbWid :200)//.height + 5
        hei = mainImage.frame.origin.y + mainImage.frame.height + 10
        
        facTitle = UILabel(frame: CGRect(x: scWid * 0.07, y: hei, width: scWid * 0.6, height: texthei.height))
        facTitle.text = self.facultyMajorInformation.facultyAbb
        facTitle.font = fm.setFontSizeBold(fs: 20)
        self.scoll.addSubview(facTitle)
        hei = facTitle.frame.origin.y + facTitle.frame.height
        
        texthei = fm.calculateHeiFromString(text:  self.facultyMajorInformation.facultyName,fontsize: fm.setFontSizeLight(fs: 15), tbWid : 200)
        facSubtitle = UILabel(frame: CGRect(x: scWid * 0.07, y:  hei, width: scWid*0.86, height: texthei.height ))
        facSubtitle.text = self.facultyMajorInformation.facultyName
        facSubtitle.font = fm.setFontSizeLight(fs: 15)
        self.scoll.addSubview(facSubtitle)
        hei = facSubtitle.frame.height + facSubtitle.frame.origin.y
        
        //        texthei = fm.calculateHeiFromString(text:  "N/A",fontsize: fm.setFontSizeLight(fs: 12), tbWid: scWid*0.54).height+10
        //        location = UIView(frame: CGRect(x: scWid * 0.37, y: hei, width: scWid*0.54, height: texthei))
        //        self.scoll.addSubview(location)
        //        let loIcon =  UIImageView(frame: CGRect(x: 0, y: 0, width: texthei, height: texthei))
        //        loIcon.image = UIImage(named: "locationnoGray")
        //        self.location.addSubview(loIcon)
        //        let loDef =  UILabel(frame: CGRect(x: texthei + 10, y: 0, width: location.bounds.width - (texthei+10), height: texthei))
        //        loDef.font = fm.setFontSizeLight(fs: 13)
        //        loDef.text = "Faculty's building"
        //        self.location.addSubview(loDef)
        //        hei = location.frame.height + location.frame.origin.y
        
        texthei = fm.calculateHeiFromString(text:  self.facultyMajorInformation.description,fontsize: fm.setFontSizeLight(fs: 12.5), tbWid : 200)
        descrip  = UITextView(frame: CGRect(x: scWid*0.06 , y: hei, width: scWid * 0.86, height: texthei.height ))
        descrip.font = fm.setFontSizeLight(fs: 14)
        descrip.textAlignment = .justified
        descrip.isUserInteractionEnabled = false
        descrip.text = "   \(self.facultyMajorInformation.description!)"
        self.scoll.addSubview(descrip)
        hei = descrip.frame.height + descrip.frame.origin.y
        
        logo = UIImageView(frame: CGRect(x: scWid*0.07, y: hei, width: scWid*0.3, height: scWid*0.3))
        logo.image = UIImage(named: "\(self.facultyMajorInformation.facultyAbb)_logo")
        self.scoll.addSubview(logo)
        
        return hei //+ scWid*0.15
    }
    
    func setTableViewSize(majorNum : Int, content : CGFloat){
        self.majorTableView.frame = CGRect(x: 0, y: content, width: scWid, height: (scWid*0.7) * CGFloat(majorNum))
        self.scoll.contentSize = CGSize(width: scWid, height: content + self.majorTableView.frame.height)
    }
    
    func startIndicator(){
        self.activityiIndicator.center = self.view.center
        self.activityiIndicator.hidesWhenStopped = true
        self.activityiIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityiIndicator)
        activityiIndicator.startAnimating()
    }
    
    func stopIndicator(){
        self.activityiIndicator.stopAnimating()
    }
    
    // Major Tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return facultyMajorInformation.marjorList.count
    }
    
    var imageCache = [String]()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: majorCellItemId, for: indexPath) as! MajorCell
        let majorIn = self.facultyMajorInformation.marjorList[indexPath.row]
        cell.selectionStyle = .none
        if majorIn.imageURL == ""{
            cell.bgMajor.image = UIImage(named: "abacImg")
        }else{
            cell.bgMajor.loadImageUsingCacheWithUrlString(urlStr: majorIn.imageURL)
            
        }
        cell.cgframe = CGRect(x: scWid*0.2, y: cell.frame.height*0.7, width: scWid*0.8, height: cell.frame.height*0.2)
        
        cell.name.text = majorIn.departmentName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MajorLayout") as! MajorViewController
        vc.facultyFullName = self.facultyMajorInformation.facultyName
        vc.facCode = self.facultyMajorInformation.faculyId
        vc.majorCode = self.facultyMajorInformation.marjorList[indexPath.row].departmentId
        //self.present(vc, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return scWid*0.7
    }
}

class  MajorCell : UITableViewCell{
    let fm = FunctionMutual.self
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
        bgMajor.image = UIImage(named: "abacImg")
        bgName.frame = cgframe
        bgName.backgroundColor = UIColor.white
        bgName.alpha = 0.7
        name.frame = cgframe
        name.textAlignment = .center
        name.font = fm.setFontSizeBold(fs: 20)
        name.textColor = UIColor.darkGray
    }
    
}
