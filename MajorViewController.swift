

import UIKit
import SWRevealViewController

class MajorViewController: UIViewController {
    
    var majorInformation : MajorModel!
    var facCode : Int!
    var majorCode : Int!
    var facultyFullName : String!
    let fm = FunctionMutual.self
    let ws = WebService.self
    
    var scoll : UIScrollView = {
        var sc = UIScrollView()
        sc.frame = CGRect(x: 0, y: 0, width: scWid, height: scHei)
        return sc
    }()
    var majorImage : UIImageView!
    var majorTitle : UILabel!
    var facName : UILabel!
    var majorDescrip : UITextView!
    var activityiIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        startIndicator()
        self.view.addSubview(scoll)
        reloadMajor(facId: facCode, majorId: majorCode,lang: CRUDSettingValue.GetUserSetting())
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadMajor(facId : Int, majorId : Int,lang:String) {
        ws.GetMajorDetailWS(facultyId: facId, departmentId: majorId,language:lang){ (responseData: MajorModel, nil) in
            DispatchQueue.main.async( execute: {
                self.majorInformation = responseData
                print(self.majorInformation.degreeName)
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
    
    func gotoMap(sender : AnyObject){
        
    }
    
    func gotoChatRoom(sender : AnyObject){
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginLayout") as! LoginViewController
        let nvc = UINavigationController(rootViewController: vc)
        vc.fromMajorProgram = true
        vc.fromFacName = self.facultyFullName
        vc.fromDepName = self.majorInformation.departmentName
        vc.fromFacId = self.facCode
        vc.fromDepId = self.majorInformation.departmentId
        self.revealViewController().setFront(nvc, animated: true)
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
        var texthei = fm.calculateHeiFromString(text: self.majorInformation.departmentName,fontsize: fm.setFontSizeBold(fs: 15), tbWid :scWid * 0.9 )//.height
        majorTitle = UILabel(frame: CGRect(x: scWid * 0.05, y: hei, width: scWid * 0.9, height: texthei.height))
        majorTitle.text = self.majorInformation.departmentName
        majorTitle.font = fm.setFontSizeBold(fs: 16)
        self.scoll.addSubview(majorTitle)
        
        hei = majorTitle.frame.origin.y + majorTitle.frame.height
        texthei = fm.calculateHeiFromString(text: self.facultyFullName,fontsize: fm.setFontSizeLight(fs: 14), tbWid : scWid*0.9)
        facName = UILabel(frame: CGRect(x: scWid * 0.05, y:  hei, width: scWid*0.9, height: texthei.height))
        facName.text = self.facultyFullName
        facName.font = fm.setFontSizeLight(fs: 15)
        self.scoll.addSubview(facName)
        
        hei = facName.frame.height + facName.frame.origin.y
        texthei = fm.calculateHeiFromString(text: self.majorInformation.description,fontsize:fm.setFontSizeLight(fs: 12.5), tbWid : 200)//.height
        majorDescrip  = UITextView(frame: CGRect(x: scWid*0.07 , y: hei + 10, width: scWid * 0.86, height: texthei.height+15))
        majorDescrip.font = fm.setFontSizeLight(fs: 14)
        majorDescrip.textAlignment = .left
        majorDescrip.isUserInteractionEnabled = false
        majorDescrip.text = "\(self.majorInformation.description!)"
        self.scoll.addSubview(majorDescrip)
        
        hei = majorDescrip.frame.height + majorDescrip.frame.origin.y
        // FIXME: CURRICULUM
        let boxCurri = UIButton(frame: CGRect(x: scWid * 0.05, y: hei, width: scWid*0.9, height: scWid*0.1))
        boxCurri.backgroundColor = UIColor.clear
        let curriIcon = UIImageView(frame: CGRect(x: scWid * 0.05, y: hei, width: scWid * 0.1, height:  scWid * 0.1))
        curriIcon.image = UIImage(named: "curriculum")
        let curriLabel = UILabel(frame: CGRect(x: (scWid*0.15)+10, y: hei, width: (scWid*0.8)-10, height:  scWid * 0.1))
        curriLabel.text = "Curriculum"
        curriLabel.textColor = UIColor.gray
        curriLabel.textAlignment = .left
        self.scoll.addSubview(curriLabel)
        self.scoll.addSubview(curriIcon)
        self.scoll.addSubview(boxCurri)
        // FIXME: MAP
        hei = curriIcon.frame.height + curriIcon.frame.origin.y + 5
        let boxMap = UIButton(frame: CGRect(x: scWid * 0.05, y: hei, width: scWid*0.9, height: scWid*0.1))
        boxMap.backgroundColor = UIColor.clear
        let mapIcon = UIImageView(frame: CGRect(x: scWid * 0.05, y: hei, width: scWid * 0.1, height:  scWid * 0.1))
        mapIcon.image = UIImage(named: "mapLocation")
        let mapLabel = UILabel(frame: CGRect(x: (scWid*0.15)+10, y: hei, width: (scWid*0.8)-10, height:  scWid * 0.1))
        mapLabel.text = "Location"
        mapLabel.textColor = UIColor.gray
        mapLabel.textAlignment = .left
        self.scoll.addSubview(mapIcon)
        self.scoll.addSubview(mapLabel)
        self.scoll.addSubview(boxMap)
        
        // FIXME: CHAT
        hei = mapIcon.frame.height + mapIcon.frame.origin.y + 5
        let boxChat = UIButton(frame: CGRect(x: scWid * 0.05, y: hei, width: scWid*0.9, height: scWid*0.1))
        boxChat.addTarget(self, action: #selector(gotoChatRoom), for: .touchUpInside)
        boxChat.backgroundColor = UIColor.clear
        let chatIcon = UIImageView(frame: CGRect(x: scWid * 0.05, y: hei, width: scWid * 0.1, height:  scWid * 0.1))
        chatIcon.image = UIImage(named: "chatGray")
        let chatLabel = UILabel(frame: CGRect(x: (scWid*0.15)+10, y: hei, width: (scWid*0.8)-10, height:  scWid * 0.1))
        chatLabel.text = "Ask with staff"
        chatLabel.textColor = UIColor.gray
        chatLabel.textAlignment = .left
        self.scoll.addSubview(chatLabel)
        self.scoll.addSubview(chatIcon)
        self.scoll.addSubview(boxChat)
        
        hei = chatIcon.frame.height + chatIcon.frame.origin.y + 20
        return hei
    }
    
}
