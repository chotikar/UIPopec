
import UIKit
import Foundation
import GoogleMaps

class FacultyMajorViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    var facultyCode : Int!
    var facultyMajorInformation = FacultyMajorModel()
    var majorCellItemId = "MajorCellItem"
    var majorTitleItemId = "MajorTitleCellItem"
    let fm = FunctionMutual.self
    var majorTableView = UITableView()
    var facMajorView = UIView()
    var loadInfo : Bool!
    var mainImage : UIImageView!
    var facTitle : UILabel!
    var facSubtitle : UILabel!
    var location : UIButton!
    var descrip : UITextView!
    var logo : UIImageView!
    var activityiIndicator : UIActivityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(majorTableView)
        majorTableView.translatesAutoresizingMaskIntoConstraints = false
        self.majorTableView.delegate = self
        self.majorTableView.dataSource = self
        self.majorTableView.register(MajorCell, forCellReuseIdentifier: majorCellItemId)
        self.majorTableView.register(MajorTitle, forCellReuseIdentifier: majorTitleItemId)
        self.majorTableView.separatorColor = UIColor.clear
        self.majorTableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.majorTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.majorTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.majorTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
        if loadInfo {
            startIndicator()
            reloadTableViewInFacMajor(facId: self.facultyCode,lang: CRUDSettingValue.GetUserSetting())
        }else{
            self.majorTableView.reloadData()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func reloadTableViewInFacMajor(facId : Int,lang:String) {
        WebService.GetFacultyDetailWS(facultyId: facId,language: lang){ (responseData: FacultyMajorModel, nil) in
            DispatchQueue.main.async( execute: {
                self.facultyMajorInformation = responseData
                self.majorTableView.reloadData()
                self.reloadInputViews()
//                self.setTableViewSize(majorNum: self.facultyMajorInformation.marjorList.count, content: self.drawLayout())
                self.stopIndicator()
            })
        }
    }

    func GoToMap(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "mapLayout") as! MapDirectionViewController
        vc.currentLatitude  = CLLocationDegrees(self.facultyMajorInformation.latitude)
        vc.currentLongtitude = CLLocationDegrees(self.facultyMajorInformation.longtitude)
        vc.currentName = self.facultyMajorInformation.buildingName as String
        let mapController = UINavigationController(rootViewController: vc)
        self.revealViewController().setFront(mapController, animated: true)
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
        if facultyMajorInformation.marjorList.count == 0 {
            return 0
        } else {
            return facultyMajorInformation.marjorList.count + 3
        }
    }

    var imageCache = [String]()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
         var cell = tableView.dequeueReusableCell(withIdentifier: majorTitleItemId) as! MajorTitle
            cell.selectionStyle = .none
            if facultyMajorInformation.imageURL == ""{
                cell.mainImage.image = UIImage(named: "abacImg")
            }else{
                cell.mainImage.loadImageUsingCacheWithUrlString(urlStr: facultyMajorInformation.imageURL)
            }
            cell.facTitle.text = self.facultyMajorInformation.facultyAbb
            cell.facSubtitle.text = self.facultyMajorInformation.facultyName
            return cell
        } else if indexPath.row == 1 {
            var cell = UITableViewCell()
            let loBut = drawLocationButton(locateName: self.facultyMajorInformation.buildingName)
            cell.addSubview(loBut)
            loBut.translatesAutoresizingMaskIntoConstraints = false
            loBut.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            loBut.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: 5).isActive = true
            return cell
        } else if indexPath.row == 2 {
            var desSize = fm.calculateHeiFromString(text: "  \(self.facultyMajorInformation.description)", fontsize: 14, tbWid: scWid * 0.9)
            var cell = UITableViewCell()
            cell.selectionStyle = .none
            var description = UITextView()
            cell.addSubview(description)
            description.translatesAutoresizingMaskIntoConstraints = false
            description.topAnchor.constraint(equalTo: cell.topAnchor, constant: 5).isActive = true
            description.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            description.heightAnchor.constraint(equalToConstant: desSize.height + 20).isActive = true
            description.widthAnchor.constraint(equalToConstant: desSize.width).isActive = true
            description.textAlignment = .justified
            description.isScrollEnabled = false
            description.isEditable = false
            description.text = "  \(self.facultyMajorInformation.description as String)"
            description.font = fm.setFontSizeLight(fs: 14)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: majorCellItemId) as! MajorCell
            let info = facultyMajorInformation.marjorList[indexPath.row - 3]
            if info.imageURL == ""{
                cell.bgMajor.image = UIImage(named: "abacImg")
            }else{
                cell.bgMajor.loadImageUsingCacheWithUrlString(urlStr: info.imageURL)
            }
            cell.name.text = info.departmentName
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 2 {
            let vc = MajorViewController()
            vc.facultyFullName = self.facultyMajorInformation.facultyName
            vc.facCode = String(self.facultyMajorInformation.faculyId)
            vc.majorCode = String(self.facultyMajorInformation.marjorList[indexPath.row - 3].departmentId)
            vc.loadInfo = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return scWid*0.5 + fm.calculateHeiFromString(text: "",fontsize: 19, tbWid :scWid * 0.6).height + fm.calculateHeiFromString(text:  "",fontsize: 15, tbWid : scWid*0.86).height + 5
        }else if indexPath.row == 1 {
            return fm.calculateHeiFromString(text: self.facultyMajorInformation.buildingName, fontsize: 13, tbWid: scWid * 0.8).height + 20
        }else if indexPath.row == 2 {
            return fm.calculateHeiFromString(text: "  \(self.facultyMajorInformation.description)", fontsize: 14, tbWid: scWid * 0.9).height + 45
        }else{
            return scWid*0.7
        }
    }
    func drawLocationButton(locateName : String) -> UIButton {
        var location = UIButton()
        var widthButton = fm.calculateHeiFromString(text: locateName, fontsize: 13, tbWid: scWid * 0.8)
        location.translatesAutoresizingMaskIntoConstraints = false
        print("WIDTH LOCATION BUTTON : \(widthButton.width + widthButton.height)")
        location.widthAnchor.constraint(equalToConstant: widthButton.width + widthButton.height + 20).isActive = true
        location.heightAnchor.constraint(equalToConstant: widthButton.height).isActive = true
        let loIcon =  UIImageView()
        location.addSubview(loIcon)
        loIcon.translatesAutoresizingMaskIntoConstraints = false
        loIcon.leftAnchor.constraint(equalTo: location.leftAnchor).isActive = true
        loIcon.centerYAnchor.constraint(equalTo: location.centerYAnchor).isActive = true
        loIcon.heightAnchor.constraint(equalToConstant: widthButton.height).isActive = true
        loIcon.widthAnchor.constraint(equalToConstant: widthButton.height).isActive = true
        loIcon.image = UIImage(named: "locationnoGray")
        let loDef =  UILabel()
        location.addSubview(loDef)
        loDef.translatesAutoresizingMaskIntoConstraints = false
        loDef.centerYAnchor.constraint(equalTo: location.centerYAnchor).isActive = true
        loDef.leftAnchor.constraint(equalTo: loIcon.rightAnchor).isActive = true
        loDef.rightAnchor.constraint(equalTo: location.rightAnchor).isActive = true
        loDef.font = fm.setFontSizeLight(fs: 13)
        loDef.text = self.facultyMajorInformation.buildingName
        location.addTarget(self,action: #selector(GoToMap), for: .touchUpInside)
        return location
    }
}

class  MajorTitle : UITableViewCell{
    let fm = FunctionMutual.self
    var mainImage = UIImageView()
    var facTitle = UILabel()
    var facSubtitle = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(mainImage)
        self.contentView.addSubview(facTitle)
        self.contentView.addSubview(facSubtitle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        mainImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mainImage.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        mainImage.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        mainImage.heightAnchor.constraint(equalToConstant: scWid*0.5).isActive = true
        var texthei = fm.calculateHeiFromString(text: "",fontsize: 19, tbWid :scWid * 0.6)
        facTitle.translatesAutoresizingMaskIntoConstraints = false
        facTitle.topAnchor.constraint(equalTo: mainImage.bottomAnchor, constant: 10).isActive = true
        facTitle.leftAnchor.constraint(equalTo: mainImage.leftAnchor, constant: 20).isActive = true
        facTitle.rightAnchor.constraint(equalTo: mainImage.rightAnchor,constant: -5).isActive = true
        facTitle.heightAnchor.constraint(equalToConstant: texthei.height).isActive = true
        facTitle.font = fm.setFontSizeBold(fs: 20)
        
        texthei = fm.calculateHeiFromString(text:  "",fontsize: 15, tbWid : scWid*0.86)
        facSubtitle.translatesAutoresizingMaskIntoConstraints = false
        facSubtitle.topAnchor.constraint(equalTo: facTitle.bottomAnchor).isActive = true
        facSubtitle.leftAnchor.constraint(equalTo: facTitle.leftAnchor).isActive = true
        facSubtitle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        facSubtitle.heightAnchor.constraint(equalToConstant: texthei.height).isActive = true
        facSubtitle.font = fm.setFontSizeLight(fs: 15)
    }
    
}

class  MajorCell : UITableViewCell{
    let fm = FunctionMutual.self
    var bgMajor = UIImageView()
    var bgName = UIView()
    var name = UILabel()
//    var cgframe = CGRect()

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
        bgMajor.translatesAutoresizingMaskIntoConstraints = false
        bgMajor.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        bgMajor.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        bgMajor.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bgMajor.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        bgMajor.image = UIImage(named: "abacImg")
        bgName.translatesAutoresizingMaskIntoConstraints = false
        bgName.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50).isActive = true
        bgName.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        bgName.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        bgName.heightAnchor.constraint(equalToConstant: 50).isActive = true
        bgName.backgroundColor = UIColor.white
        bgName.alpha = 0.8
        name.translatesAutoresizingMaskIntoConstraints = false
        name.leftAnchor.constraint(equalTo: bgName.leftAnchor).isActive = true
        name.rightAnchor.constraint(equalTo: bgName.rightAnchor).isActive = true
        name.bottomAnchor.constraint(equalTo: bgName.bottomAnchor).isActive = true
        name.topAnchor.constraint(equalTo: bgName.topAnchor).isActive = true
        name.textAlignment = .center
        name.font = fm.setFontSizeBold(fs: 20)
        name.textColor = UIColor.darkGray
    }
}
