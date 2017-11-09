
import UIKit
import Foundation
import SWRevealViewController
import CoreData

class MajorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Require fac Code and major code
    var facCode: String!
    var majorCode: String!
    var majorInformation = MajorModel()
    var facultyFullName: String!
    let fm = FunctionMutual.self
    let ws = WebService.self
    let dc = CRUDDepartmentMessage.self
    
    var loadInfo : Bool!
    var table = UITableView()
    let majorTitleID = "majorTitleId"
    var activityiIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var lang = CRUDSettingValue.GetUserSetting()
    var boxChat: UIButton!
    var oneLineSize : CGRect!
    var boxCall : UIButton!
    var boxCallDetail : UIView!
    var phoneCallBut : UIButton!
    var phoneLabel : UILabel!
    var mailBut : UIButton!
    var mailLabel : UILabel!
    var containerViewBottomAnchor : NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oneLineSize = fm.calculateHeiFromString(text: "", fontsize: 15, tbWid: scWid * 0.9)
        self.view.addSubview(table)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.register(MajorTitle, forCellReuseIdentifier: majorTitleID)
        table.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        table.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        table.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        containerViewBottomAnchor?.constant = -(oneLineSize.height * 2 + 10)
        table.separatorColor = UIColor.clear
        startIndicator()
        if loadInfo {
            reloadMajor(facId: facCode, majorId: majorCode,lang: lang)
        }else{
            self.table.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadMajor(facId : String, majorId : String, lang:String) {
        print("Faculty ID : \(facId), Major ID: \(majorId)")
        ws.GetMajorDetailWS(facultyId: facId, departmentId: majorId, language:lang){ (responseData: MajorModel, nil) in
            DispatchQueue.main.async( execute: {
                self.majorInformation = responseData
                print("IMAGE URL ::\(self.majorInformation.imageURL)")
                self.table.reloadData()
                self.stopIndicator()
            })
        }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    var imageCache = [String]()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: majorTitleID) as! MajorTitle
            cell.selectionStyle = .none
            if majorInformation.imageURL == "" {
                cell.mainImage.image = UIImage(named: "abacImg")
            }else{
                cell.mainImage.loadImageUsingCacheWithUrlString(urlStr: majorInformation.imageURL)
            }
            cell.facTitle.text = majorInformation.departmentAbb
            cell.facSubtitle.text = lang == "T" ? majorInformation.departmentThName : majorInformation.departmentEnName
            return cell
        }else if indexPath.row == 1 {
            let desSize = fm.calculateHeiFromString(text: "     \(majorInformation.description)", fontsize: 14, tbWid: scWid * 0.9)
            var cell = UITableViewCell()
            cell.selectionStyle = .none
            var description = UITextView()
            cell.addSubview(description)
            description.translatesAutoresizingMaskIntoConstraints = false
            description.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            description.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            description.heightAnchor.constraint(equalToConstant: desSize.height + 30).isActive = true
            description.widthAnchor.constraint(equalToConstant: desSize.width).isActive = true
            description.isScrollEnabled = false
            description.isEditable = false
            description.font = fm.setFontSizeLight(fs: 14)
            description.textAlignment = .justified
            description.text = "     \(majorInformation.description as String)"
            return cell
        }else{
            var cell = UITableViewCell()
            var addView = drawAdditionView()
            cell.addSubview(addView)
            addView.translatesAutoresizingMaskIntoConstraints = false
            addView.leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
            addView.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            addView.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
            addView.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
             return scWid*0.5 + fm.calculateHeiFromString(text: "",fontsize: 19, tbWid :scWid * 0.6).height + oneLineSize.height + 15
        }else if indexPath.row == 1 {
            return fm.calculateHeiFromString(text: "     \(majorInformation.description as String)", fontsize: 14, tbWid: scWid * 0.9).height + 30
        }else{
           return  (oneLineSize.height * 5) + 80
        }
    }
    func gotoCurriculum(sender : AnyObject){
        let vc = CurriculumViewController()
        vc.programName = lang == "E" ? self.majorInformation.departmentEnName : self.majorInformation.departmentThName
        vc.facultyId = String(facCode)
        vc.programId = String(majorCode)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
  
    func gotoChatRoom(sender : AnyObject){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "messageLayout") as! MessageViewController
        vc.goToChatController = true
        vc.fromFacName = self.facultyFullName
        vc.fromDepEnName = self.majorInformation.departmentEnName
        vc.fromDepThName = self.majorInformation.departmentThName
        vc.fromDepAbb = self.majorInformation.departmentAbb
        vc.fromFacId = String(self.facCode)
        vc.fromDepId = String(self.majorInformation.departmentId)
        let messageController = UINavigationController(rootViewController: vc)
        self.revealViewController().setFront(messageController, animated: true)
    }
    
    func callPhoneAction(){
        print(">>>>>>>>>>callPhoneAction")
        if containerViewBottomAnchor?.constant == 0 {
            containerViewBottomAnchor?.constant = -(oneLineSize.height * 2 + 10)
        }else{
            containerViewBottomAnchor?.constant = 0
        }
    }
    
    func drawAdditionView() -> UIView {
        let view = UIView()
        var boxCurri = UIButton()
        view.addSubview(boxCurri)
        boxCurri.translatesAutoresizingMaskIntoConstraints = false
        boxCurri.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        boxCurri.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        boxCurri.heightAnchor.constraint(equalToConstant: oneLineSize.height).isActive = true
        boxCurri.widthAnchor.constraint(equalToConstant: scWid * 0.9).isActive = true
        boxCurri.backgroundColor = UIColor.clear
        var curriIcon = UIImageView()
        boxCurri.addSubview(curriIcon)
        curriIcon.translatesAutoresizingMaskIntoConstraints = false
        curriIcon.heightAnchor.constraint(equalToConstant: oneLineSize.height).isActive = true
        curriIcon.widthAnchor.constraint(equalToConstant: oneLineSize.height).isActive = true
        curriIcon.centerYAnchor.constraint(equalTo: boxCurri.centerYAnchor).isActive = true
        curriIcon.leftAnchor.constraint(equalTo: boxCurri.leftAnchor, constant: 5).isActive = true
        curriIcon.image = UIImage(named: "curriculum")
        let curriLabel = UILabel()
        boxCurri.addSubview(curriLabel)
        curriLabel.translatesAutoresizingMaskIntoConstraints = false
        curriLabel.leftAnchor.constraint(equalTo: curriIcon.rightAnchor, constant: 10).isActive = true
        curriLabel.rightAnchor.constraint(equalTo: boxCurri.rightAnchor, constant: -5).isActive = true
        curriLabel.centerYAnchor.constraint(equalTo: boxCurri.centerYAnchor).isActive = true
        curriLabel.text = lang == "T" ? "หลักสูตร" : "Curriculum"
        curriLabel.textColor = UIColor.gray
        curriLabel.textAlignment = .left
        curriLabel.font = fm.setFontSizeLight(fs: 15)
        boxCurri.addTarget(self, action: #selector(gotoCurriculum), for: .touchUpInside)
        
        boxCall = UIButton()
        view.addSubview(boxCall)
        boxCall.translatesAutoresizingMaskIntoConstraints = false
        boxCall.topAnchor.constraint(equalTo: boxCurri.bottomAnchor, constant: 10).isActive = true
        boxCall.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        boxCall.heightAnchor.constraint(equalToConstant: oneLineSize.height).isActive = true
        boxCall.widthAnchor.constraint(equalToConstant: scWid * 0.9).isActive = true
        boxCall.backgroundColor = UIColor.clear
        boxCall.addTarget(self, action: #selector(callPhoneAction), for: .touchUpInside)
        var callIcon = UIImageView()
        boxCall.addSubview(callIcon)
        callIcon.translatesAutoresizingMaskIntoConstraints = false
        callIcon.heightAnchor.constraint(equalToConstant: oneLineSize.height).isActive = true
        callIcon.widthAnchor.constraint(equalToConstant: oneLineSize.height).isActive = true
        callIcon.centerYAnchor.constraint(equalTo: boxCall.centerYAnchor).isActive = true
        callIcon.leftAnchor.constraint(equalTo: boxCall.leftAnchor, constant: 5).isActive = true
        callIcon.image =  UIImage(named: "contact_card")
        var callLabel = UILabel()
        boxCall.addSubview(callLabel)
        callLabel.translatesAutoresizingMaskIntoConstraints = false
        callLabel.leftAnchor.constraint(equalTo: callIcon.rightAnchor, constant: 10).isActive = true
        callLabel.rightAnchor.constraint(equalTo: boxCall.rightAnchor, constant: -5).isActive = true
        callLabel.centerYAnchor.constraint(equalTo: boxCall.centerYAnchor).isActive = true
        callLabel.text = lang == "T" ? "ติดต่อ" : "Contact"
        callLabel.textColor = UIColor.gray
        callLabel.textAlignment = .left
        callLabel.font = fm.setFontSizeLight(fs: 15)
        boxCallDetail = UIView()
        view.addSubview(boxCallDetail)
        boxCallDetail.translatesAutoresizingMaskIntoConstraints = false
        boxCallDetail.topAnchor.constraint(equalTo: boxCall.bottomAnchor, constant: 10).isActive = true
        boxCallDetail.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        boxCallDetail.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        boxCallDetail.heightAnchor.constraint(equalToConstant: oneLineSize.height * 2 + 10).isActive = true
        phoneCallBut = UIButton()
        boxCallDetail.addSubview(phoneCallBut)
        phoneCallBut.translatesAutoresizingMaskIntoConstraints = false
        phoneCallBut.topAnchor.constraint(equalTo: boxCallDetail.topAnchor).isActive = true
        phoneCallBut.leftAnchor.constraint(equalTo: boxCallDetail.leftAnchor).isActive = true
        phoneCallBut.rightAnchor.constraint(equalTo: boxCallDetail.rightAnchor).isActive = true
        phoneCallBut.heightAnchor.constraint(equalToConstant: oneLineSize.height).isActive = true
        phoneCallBut.backgroundColor = UIColor.clear
        var phoneIcon = UIImageView()
        phoneCallBut.addSubview(phoneIcon)
        phoneIcon.translatesAutoresizingMaskIntoConstraints = false
        phoneIcon.heightAnchor.constraint(equalToConstant: oneLineSize.height).isActive = true
        phoneIcon.widthAnchor.constraint(equalToConstant: oneLineSize.height).isActive = true
        phoneIcon.centerYAnchor.constraint(equalTo: phoneCallBut.centerYAnchor).isActive = true
        phoneIcon.leftAnchor.constraint(equalTo: phoneCallBut.leftAnchor, constant: 10).isActive = true
        phoneIcon.image =  UIImage(named: "phone-call")
        phoneLabel = UILabel()
        phoneCallBut.addSubview(phoneLabel)
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneLabel.leftAnchor.constraint(equalTo: phoneIcon.rightAnchor, constant: 5).isActive = true
        phoneLabel.rightAnchor.constraint(equalTo: phoneCallBut.rightAnchor, constant: -5).isActive = true
        phoneLabel.heightAnchor.constraint(equalToConstant: oneLineSize.height).isActive = true
        phoneLabel.centerYAnchor.constraint(equalTo: phoneCallBut.centerYAnchor).isActive = true
        phoneLabel.text = "Mobile Number"
        phoneLabel.textColor = UIColor.gray
        phoneLabel.textAlignment = .left
        phoneLabel.font = fm.setFontSizeLight(fs: 15)
        mailBut = UIButton()
        boxCallDetail.addSubview(mailBut)
        mailBut.backgroundColor = UIColor.red
        mailBut.translatesAutoresizingMaskIntoConstraints = false
        mailBut.topAnchor.constraint(equalTo: phoneCallBut.bottomAnchor, constant: 10).isActive = true
        mailBut.heightAnchor.constraint(equalToConstant: oneLineSize.height).isActive = true
        mailBut.leftAnchor.constraint(equalTo: boxCallDetail.leftAnchor).isActive = true
        mailBut.rightAnchor.constraint(equalTo: boxCallDetail.rightAnchor).isActive = true
        mailBut.backgroundColor = UIColor.clear
        var mailIcon = UIImageView()
        phoneCallBut.addSubview(mailIcon)
        mailIcon.translatesAutoresizingMaskIntoConstraints = false
        mailIcon.heightAnchor.constraint(equalToConstant: oneLineSize.height).isActive = true
        mailIcon.widthAnchor.constraint(equalToConstant: oneLineSize.height).isActive = true
        mailIcon.centerYAnchor.constraint(equalTo: mailBut.centerYAnchor).isActive = true
        mailIcon.leftAnchor.constraint(equalTo: mailBut.leftAnchor, constant: 10).isActive = true
        mailIcon.image =  UIImage(named: "email")
        mailLabel = UILabel()
        phoneCallBut.addSubview(mailLabel)
        mailLabel.translatesAutoresizingMaskIntoConstraints = false
        mailLabel.leftAnchor.constraint(equalTo: mailIcon.rightAnchor, constant: 10).isActive = true
        mailLabel.rightAnchor.constraint(equalTo: mailBut.rightAnchor, constant: -5).isActive = true
        mailLabel.centerYAnchor.constraint(equalTo: mailBut.centerYAnchor).isActive = true
        mailLabel.heightAnchor.constraint(equalToConstant: oneLineSize.height).isActive = true
        mailLabel.text = "E-mail"
        mailLabel.textColor = UIColor.gray
        mailLabel.textAlignment = .left
        mailLabel.font = fm.setFontSizeLight(fs: 15)
        
        var boxChat = UIButton()
        view.addSubview(boxChat)
        boxChat.translatesAutoresizingMaskIntoConstraints = false
        boxChat.topAnchor.constraint(equalTo: boxCallDetail.bottomAnchor, constant: 10).isActive = true
        boxChat.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        boxChat.heightAnchor.constraint(equalToConstant: oneLineSize.height).isActive = true
        boxChat.widthAnchor.constraint(equalToConstant: scWid * 0.9).isActive = true
        boxChat.backgroundColor = UIColor.clear
        var chatIcon = UIImageView()
        boxChat.addSubview(chatIcon)
        chatIcon.translatesAutoresizingMaskIntoConstraints = false
        chatIcon.heightAnchor.constraint(equalToConstant: oneLineSize.height).isActive = true
        chatIcon.widthAnchor.constraint(equalToConstant: oneLineSize.height).isActive = true
        chatIcon.centerYAnchor.constraint(equalTo: boxChat.centerYAnchor).isActive = true
        chatIcon.leftAnchor.constraint(equalTo: boxChat.leftAnchor, constant: 5).isActive = true
        chatIcon.image =  UIImage(named: "chatGray")
        var chatLabel = UILabel()
        boxChat.addSubview(chatLabel)
        chatLabel.translatesAutoresizingMaskIntoConstraints = false
        chatLabel.leftAnchor.constraint(equalTo: chatIcon.rightAnchor, constant: 5).isActive = true
        chatLabel.rightAnchor.constraint(equalTo: boxChat.rightAnchor, constant: -5).isActive = true
        chatLabel.centerYAnchor.constraint(equalTo: boxChat.centerYAnchor).isActive = true
        chatLabel.text = lang == "T" ? "สอบถามเรา" : "Ask with staff"
        chatLabel.textColor = UIColor.gray
        chatLabel.textAlignment = .left
        chatLabel.font = fm.setFontSizeLight(fs: 15)
        boxChat.addTarget(self, action: #selector(gotoChatRoom), for: .touchUpInside)
        return view
    }
}








//class MajorViewController: UIViewController {
//
//    // Require fac Code and major code
//    var facCode: Int!
//    var majorCode: Int!
//    ///
//    var majorInformation: MajorModel!
//    var facultyFullName: String!
//    let fm = FunctionMutual.self
//    let ws = WebService.self
//    let dc = CRUDDepartmentMessage.self
//
//    var loadInfo : Bool!
//
//    var scoll: UIScrollView = {
//        var sc = UIScrollView()
//        sc.frame = CGRect(x: 0, y: 0, width: scWid, height: scHei)
//        return sc
//    }()
//    var addressView = UIView()
//    var addressHei: CGFloat!
//    var majorImage: UIImageView!
//    var majorTitle: UILabel!
//    var facName: UILabel!
//    var majorDescrip: UITextView!
//    var activityiIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
//    var lang = CRUDSettingValue.GetUserSetting()
//    var boxChat: UIButton!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.navigationController?.navigationBar.tintColor = UIColor.white
//        startIndicator()
//        self.view.addSubview(scoll)
//        if loadInfo {
//            reloadMajor(facId: facCode, majorId: majorCode,lang: lang)
//        }
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    func reloadMajor(facId : Int, majorId : Int,lang:String) {
//        ws.GetMajorDetailWS(facultyId: facId, departmentId: majorId,language:lang){ (responseData: MajorModel, nil) in
//            DispatchQueue.main.async( execute: {
//                self.majorInformation = responseData
//                self.reloadInputViews()
//                self.scoll.contentSize = CGSize(width: scWid, height: self.drawMajorInformation() + self.addressHei)
//                self.stopIndicator()
//            })
//        }
//    }
//
//    func startIndicator(){
//        self.activityiIndicator.center = self.view.center
//        self.activityiIndicator.hidesWhenStopped = true
//        self.activityiIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
//        view.addSubview(activityiIndicator)
//        activityiIndicator.startAnimating()
//    }
//
//    func stopIndicator(){
//        self.activityiIndicator.stopAnimating()
//    }
//
//    func gotoCurriculum(sender : AnyObject){
//        let vc = CurriculumViewController()
//        vc.facultyId = String(facCode)
//        vc.programeId = String(majorCode)
//        self.navigationController?.pushViewController(vc, animated: true)
//
//    }
//
//    func showAddress(sender : AnyObject){
//        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseIn], animations: {
//            if self.addressView.frame.height != 0 {
//                self.addressView.frame.size.height = 0
//                self.addressView.isHidden = true
//            }else{
//                self.addressView.frame.size.height = self.addressHei
//                self.addressView.isHidden = false
//            }
//            self.boxChat.frame.origin.y = self.addressView.frame.height + self.addressView.frame.origin.y
//        }, completion: nil)
//    }
//
//    func gotoChatRoom(sender : AnyObject){
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "messageLayout") as! MessageViewController
//        vc.goToChatController = true
//        vc.fromFacName = self.facultyFullName
//        vc.fromDepEnName = self.majorInformation.departmentEnName
//        vc.fromDepThName = self.majorInformation.departmentThName
//        vc.fromDepAbb = self.majorInformation.departmentAbb
//        vc.fromFacId = String(self.facCode)
//        vc.fromDepId = String(self.majorInformation.departmentId)
//        let messageController = UINavigationController(rootViewController: vc)
//        self.revealViewController().setFront(messageController, animated: true)
//    }
//
//    func drawMajorInformation() ->CGFloat {
//        var hei : CGFloat
//        majorImage = UIImageView(frame: CGRect(x: 0, y: 0, width: scWid, height: scWid*0.7))
//
//        if self.majorInformation.imageURL == "" {
//            majorImage.image = UIImage(named: "abacImg")
//        }else{
//            majorImage.loadImageUsingCacheWithUrlString(urlStr: self.majorInformation.imageURL)
//        }
//        self.scoll.addSubview(majorImage)
//        hei = majorImage.frame.origin.y + majorImage.frame.height+20
//        var texthei = fm.calculateHeiFromString(text: lang == "E" ? self.majorInformation.departmentEnName : self.majorInformation.departmentThName,fontsize: 17, tbWid :scWid * 0.8)
//        majorTitle = UILabel(frame: CGRect(x: scWid * 0.07, y: hei, width: scWid * 0.9, height: texthei.height + 5))
//        majorTitle.text = lang == "E" ? self.majorInformation.departmentEnName : self.majorInformation.departmentThName
//        majorTitle.font = fm.setFontSizeBold(fs: 20)
//        self.scoll.addSubview(majorTitle)
//
//        hei = majorTitle.frame.origin.y + majorTitle.frame.height + 10
//        texthei = fm.calculateHeiFromString(text: self.facultyFullName,fontsize: 15, tbWid : scWid * 0.8)
//        facName = UILabel(frame: CGRect(x: scWid * 0.07, y:  hei, width: scWid*0.9, height: texthei.height))
//        facName.text = self.facultyFullName
//        facName.font = fm.setFontSizeLight(fs: 15)
//        self.scoll.addSubview(facName)
//
//        hei = facName.frame.height + facName.frame.origin.y
//        texthei = fm.calculateHeiFromString(text: self.majorInformation.description,fontsize: 14, tbWid : scWid * 0.8)
//        majorDescrip  = UITextView(frame: CGRect(x: scWid*0.06 , y: hei + 10, width: scWid * 0.86, height: texthei.height + 15))
//        majorDescrip.font = fm.setFontSizeLight(fs: 14)
//        majorDescrip.textAlignment = .left
//        majorDescrip.isUserInteractionEnabled = false
//        majorDescrip.text = "    \(self.majorInformation.description!)"
//        self.scoll.addSubview(majorDescrip)
//
//        hei = majorDescrip.frame.height + majorDescrip.frame.origin.y
//        // FIXME: CURRICULUM
//        let boxCurri = UIButton(frame: CGRect(x: scWid * 0.05, y: hei, width: scWid*0.9, height: scWid*0.1))
//        boxCurri.backgroundColor = UIColor.clear
//        boxCurri.addTarget(self, action: #selector(gotoCurriculum), for: .touchUpInside)
//        let curriIcon = UIImageView(frame: CGRect(x: scWid * 0.05, y: hei, width: scWid * 0.07, height:  scWid * 0.07))
//        curriIcon.image = UIImage(named: "curriculum")
//        let curriLabel = UILabel(frame: CGRect(x: (scWid*0.15), y: hei - 5, width: (scWid*0.8)-10, height:  scWid * 0.1))
//        curriLabel.text = lang == "T" ? "หลักสูตร" : "Curriculum"
//        curriLabel.textColor = UIColor.gray
//        curriLabel.textAlignment = .left
//        curriLabel.font = fm.setFontSizeLight(fs: 15)
//        self.scoll.addSubview(boxCurri)
//        self.scoll.addSubview(curriLabel)
//        self.scoll.addSubview(curriIcon)
//
//        // FIXME: MAP
//        hei = curriIcon.frame.height + curriIcon.frame.origin.y + 5
//        let boxMap = UIButton(frame: CGRect(x: scWid * 0.05, y: hei, width: scWid*0.9, height: scWid*0.1))
//        boxMap.backgroundColor = UIColor.clear
//        let mapIcon = UIImageView(frame: CGRect(x: scWid * 0.05, y: hei, width: scWid * 0.07, height:  scWid * 0.07))
//        mapIcon.image = UIImage(named: "contact_card")
//        let mapLabel = UILabel(frame: CGRect(x: (scWid*0.15), y: hei - 5, width: (scWid*0.8)-10, height:  scWid * 0.1))
//        mapLabel.text = lang == "T" ? "ติดต่อ" : "Contact"
//        mapLabel.textColor = UIColor.gray
//        mapLabel.textAlignment = .left
//        mapLabel.font = fm.setFontSizeLight(fs: 15)
//        boxMap.addTarget(self, action: #selector(showAddress), for: .touchUpInside)
//        self.scoll.addSubview(boxMap)
//        self.scoll.addSubview(mapIcon)
//        self.scoll.addSubview(mapLabel)
//
//        hei = mapIcon.frame.height + mapIcon.frame.origin.y
//        drawContactView()
//        addressView.frame = CGRect(x: scWid * 0.05, y: hei, width: scWid*0.9, height: 0)
//        addressView.isHidden = true
//        self.scoll.addSubview(addressView)
//
//        // FIXME: CHAT
//        hei = addressView.frame.height + addressView.frame.origin.y
//        boxChat = UIButton(frame: CGRect(x: 0, y: hei, width: scWid*0.9, height: scWid*0.1))
//        boxChat.addTarget(self, action: #selector(gotoChatRoom), for: .touchUpInside)
//        boxChat.backgroundColor = UIColor.clear
//        let chatIcon = UIImageView(frame: CGRect(x: scWid * 0.05, y: 5, width: scWid * 0.07, height:  scWid * 0.07))
//        chatIcon.image = UIImage(named: "chatGray")
//        let chatLabel = UILabel(frame: CGRect(x: (scWid*0.15), y: 0, width: (scWid*0.8)-10, height:  scWid * 0.1))
//        chatLabel.text = lang == "T" ? "สอบถามเรา" : "Ask with staff"
//        chatLabel.textColor = UIColor.gray
//        chatLabel.textAlignment = .left
//        chatLabel.font = fm.setFontSizeLight(fs: 15)
//        self.scoll.addSubview(boxChat)
//        self.boxChat.addSubview(chatLabel)
//        self.boxChat.addSubview(chatIcon)
//
//        hei = boxChat.frame.height + boxChat.frame.origin.y + 50
//        return hei
//    }
//
//    func drawContactView(){
//        let widText = scWid - (scWid * 0.07 + 20)
//        var heiText = CGFloat(5)
//        let contactIcon = UIImageView(frame: CGRect(x: 10, y: 5, width: scWid * 0.07, height: scWid * 0.07))
//        contactIcon.image = UIImage(named: "phone-call")
//        let contactInfor = UITextView(frame: CGRect(x: 40, y: heiText, width: widText, height: self.fm.calculateHeiFromString(text: "", fontsize: 15, tbWid: widText).height));
//        //        contactInfor.target(forAction: #selector(fm.callByNumber(phoneNumber: "0854056700")), withSender: self)
//        self.addressView.addSubview(contactIcon)
//        self.addressView.addSubview(contactInfor)
//        heiText = contactInfor.frame.height + contactInfor.frame.origin.y + 5
//        let emailIcon = UIImageView(frame: CGRect(x: 10, y: heiText, width: scWid * 0.07, height: scWid * 0.07))
//        emailIcon.image = UIImage(named: "email")
//        let emailInfor = UITextView(frame: CGRect(x: 40, y: heiText, width: widText, height: self.fm.calculateHeiFromString(text: "", fontsize: 15, tbWid: widText).height));
//        self.addressView.addSubview(emailIcon)
//        self.addressView.addSubview(emailInfor)
//        self.addressHei = emailInfor.frame.origin.y + emailInfor.frame.height + 5
//    }
//}

