
import UIKit
import SWRevealViewController
import CoreData

class MajorViewController: UIViewController {
    
    var majorInformation: MajorModel!
    var facCode: Int!
    var majorCode: Int!
    var facultyFullName: String!
    let fm = FunctionMutual.self
    let ws = WebService.self
    let dc = CRUDDepartmentMessage.self
    
    var scoll: UIScrollView = {
        var sc = UIScrollView()
        sc.frame = CGRect(x: 0, y: 0, width: scWid, height: scHei)
        return sc
    }()
    var addressView = UIView()
    var addressHei: CGFloat!
    var majorImage: UIImageView!
    var majorTitle: UILabel!
    var facName: UILabel!
    var majorDescrip: UITextView!
    var activityiIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var lang = CRUDSettingValue.GetUserSetting()
    var boxChat: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        startIndicator()
        self.view.addSubview(scoll)
        reloadMajor(facId: facCode, majorId: majorCode,lang: lang) 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadMajor(facId : Int, majorId : Int,lang:String) {
        ws.GetMajorDetailWS(facultyId: facId, departmentId: majorId,language:lang){ (responseData: MajorModel, nil) in
            DispatchQueue.main.async( execute: {
                self.majorInformation = responseData
                self.reloadInputViews()
                self.scoll.contentSize = CGSize(width: scWid, height: self.drawMajorInformation())
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
    
    func gotoCurriculum(sender : AnyObject){
        
    }
    
    func showAddress(sender : AnyObject){
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseIn], animations: {
            if self.addressView.frame.height != 0 {
                self.addressView.frame.size.height = 0
                self.boxChat.frame.origin.y = self.addressView.frame.height + self.addressView.frame.origin.y
                self.addressView.isHidden = true
            }else{
                self.addressView.frame.size.height = self.addressHei
                self.boxChat.frame.origin.y = self.addressView.frame.height + self.addressView.frame.origin.y
                self.addressView.isHidden = false
            }
        }, completion: nil)
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
    
    func drawMajorInformation() ->CGFloat {
        var hei : CGFloat
        majorImage = UIImageView(frame: CGRect(x: 0, y: 0, width: scWid, height: scWid*0.7))
        
        if self.majorInformation.imageURL == "" {
            majorImage.image = UIImage(named: "abacImg")
        }else{
            majorImage.loadImageUsingCacheWithUrlString(urlStr: self.majorInformation.imageURL)
        }
        self.scoll.addSubview(majorImage)
        hei = majorImage.frame.origin.y + majorImage.frame.height+20
        var texthei = fm.calculateHeiFromString(text: lang == "E" ? self.majorInformation.departmentEnName : self.majorInformation.departmentThName,fontsize: 17, tbWid :scWid * 0.8)
        majorTitle = UILabel(frame: CGRect(x: scWid * 0.07, y: hei, width: scWid * 0.9, height: texthei.height + 5))
        majorTitle.text = lang == "E" ? self.majorInformation.departmentEnName : self.majorInformation.departmentThName
        majorTitle.font = fm.setFontSizeBold(fs: 20)
        self.scoll.addSubview(majorTitle)
        
        hei = majorTitle.frame.origin.y + majorTitle.frame.height + 10
        texthei = fm.calculateHeiFromString(text: self.facultyFullName,fontsize: 15, tbWid : scWid * 0.8)
        facName = UILabel(frame: CGRect(x: scWid * 0.07, y:  hei, width: scWid*0.9, height: texthei.height))
        facName.text = self.facultyFullName
        facName.font = fm.setFontSizeLight(fs: 15)
        self.scoll.addSubview(facName)
        
        hei = facName.frame.height + facName.frame.origin.y
        texthei = fm.calculateHeiFromString(text: self.majorInformation.description,fontsize: 14, tbWid : scWid * 0.8)
        majorDescrip  = UITextView(frame: CGRect(x: scWid*0.06 , y: hei + 10, width: scWid * 0.86, height: texthei.height + 15))
        majorDescrip.font = fm.setFontSizeLight(fs: 14)
        majorDescrip.textAlignment = .left
        majorDescrip.isUserInteractionEnabled = false
        majorDescrip.text = "    \(self.majorInformation.description!)"
        self.scoll.addSubview(majorDescrip)
        
        hei = majorDescrip.frame.height + majorDescrip.frame.origin.y
        // FIXME: CURRICULUM
        let boxCurri = UIButton(frame: CGRect(x: scWid * 0.05, y: hei, width: scWid*0.9, height: scWid*0.1))
        boxCurri.backgroundColor = UIColor.clear
        let curriIcon = UIImageView(frame: CGRect(x: scWid * 0.05, y: hei, width: scWid * 0.07, height:  scWid * 0.07))
        curriIcon.image = UIImage(named: "curriculum")
        let curriLabel = UILabel(frame: CGRect(x: (scWid*0.15), y: hei - 5, width: (scWid*0.8)-10, height:  scWid * 0.1))
        curriLabel.text = lang == "T" ? "หลักสูตร" : "Curriculum"
        curriLabel.textColor = UIColor.gray
        curriLabel.textAlignment = .left
        curriLabel.font = fm.setFontSizeLight(fs: 15)
        self.scoll.addSubview(boxCurri)
        self.scoll.addSubview(curriLabel)
        self.scoll.addSubview(curriIcon)
        
        // FIXME: MAP
        hei = curriIcon.frame.height + curriIcon.frame.origin.y + 5
        let boxMap = UIButton(frame: CGRect(x: scWid * 0.05, y: hei, width: scWid*0.9, height: scWid*0.1))
        boxMap.backgroundColor = UIColor.clear
        let mapIcon = UIImageView(frame: CGRect(x: scWid * 0.05, y: hei, width: scWid * 0.07, height:  scWid * 0.07))
        mapIcon.image = UIImage(named: "contact_card")
        let mapLabel = UILabel(frame: CGRect(x: (scWid*0.15), y: hei - 5, width: (scWid*0.8)-10, height:  scWid * 0.1))
        mapLabel.text = lang == "T" ? "ติดต่อ" : "Contact"
        mapLabel.textColor = UIColor.gray
        mapLabel.textAlignment = .left
        mapLabel.font = fm.setFontSizeLight(fs: 15)
        boxMap.addTarget(self, action: #selector(showAddress), for: .touchUpInside)
        self.scoll.addSubview(boxMap)
        self.scoll.addSubview(mapIcon)
        self.scoll.addSubview(mapLabel)
        
        hei = mapIcon.frame.height + mapIcon.frame.origin.y
        drawContactView()
        addressView.frame = CGRect(x: scWid * 0.05, y: hei, width: scWid*0.9, height: 0)
        addressView.isHidden = true
        self.scoll.addSubview(addressView)
        
        // FIXME: CHAT
        hei = addressView.frame.height + addressView.frame.origin.y
        boxChat = UIButton(frame: CGRect(x: 0, y: hei, width: scWid*0.9, height: scWid*0.1))
        boxChat.addTarget(self, action: #selector(gotoChatRoom), for: .touchUpInside)
        boxChat.backgroundColor = UIColor.clear
        let chatIcon = UIImageView(frame: CGRect(x: scWid * 0.05, y: 5, width: scWid * 0.07, height:  scWid * 0.07))
        chatIcon.image = UIImage(named: "chatGray")
        let chatLabel = UILabel(frame: CGRect(x: (scWid*0.15), y: 0, width: (scWid*0.8)-10, height:  scWid * 0.1))
        chatLabel.text = lang == "T" ? "สอบถามเรา" : "Ask with staff"
        chatLabel.textColor = UIColor.gray
        chatLabel.textAlignment = .left
        chatLabel.font = fm.setFontSizeLight(fs: 15)
        self.scoll.addSubview(boxChat)
        self.boxChat.addSubview(chatLabel)
        self.boxChat.addSubview(chatIcon)
        
        hei = boxChat.frame.height + boxChat.frame.origin.y + 100
        return hei
    }
    
    func drawContactView(){
        let widText = scWid - (scWid * 0.07 + 20)
        var heiText = CGFloat(5)
        let contactIcon = UIImageView(frame: CGRect(x: 10, y: 5, width: scWid * 0.07, height: scWid * 0.07))
        contactIcon.image = UIImage(named: "phone-call")
        let contactInfor = UITextView(frame: CGRect(x: 40, y: heiText, width: widText, height: self.fm.calculateHeiFromString(text: "", fontsize: 15, tbWid: widText).height));
//        contactInfor.target(forAction: #selector(fm.callByNumber(phoneNumber: "0854056700")), withSender: self)
        self.addressView.addSubview(contactIcon)
        self.addressView.addSubview(contactInfor)
        heiText = contactInfor.frame.height + contactInfor.frame.origin.y + 5
        let emailIcon = UIImageView(frame: CGRect(x: 10, y: heiText, width: scWid * 0.07, height: scWid * 0.07))
        emailIcon.image = UIImage(named: "email")
        let emailInfor = UITextView(frame: CGRect(x: 40, y: heiText, width: widText, height: self.fm.calculateHeiFromString(text: "", fontsize: 15, tbWid: widText).height));
        self.addressView.addSubview(emailIcon)
        self.addressView.addSubview(emailInfor)
        self.addressHei = emailInfor.frame.origin.y + emailInfor.frame.height + 5
    }
}
