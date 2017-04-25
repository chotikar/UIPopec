

import UIKit

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

    override func viewDidLoad() {
        super.viewDidLoad()
         self.view.addSubview(scoll)
        self.navigationController?.navigationBar.tintColor = UIColor.white
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
            })
        }
    }

    func drawMajorInformation() ->CGFloat {
        var hei : CGFloat
        majorImage = UIImageView(frame: CGRect(x: 0, y: 0, width: scWid, height: scWid*0.7))
        majorImage.image = UIImage(named: "abacImg")
        self.scoll.addSubview(majorImage)
        
        hei = majorImage.frame.origin.y + majorImage.frame.height+20
        var texthei = fm.calculateHeiFromString(text: self.majorInformation.departmentName,fontsize: fm.setFontSizeBold(fs: 15), tbWid :scWid * 0.9 ).height
        majorTitle = UILabel(frame: CGRect(x: scWid * 0.05, y: hei, width: scWid * 0.9, height: texthei))
        majorTitle.text = self.majorInformation.departmentName
        majorTitle.font = fm.setFontSizeBold(fs: 16)
        self.scoll.addSubview(majorTitle)
        
        hei = majorTitle.frame.origin.y + majorTitle.frame.height
        texthei = fm.calculateHeiFromString(text: self.facultyFullName,fontsize: fm.setFontSizeLight(fs: 14), tbWid : scWid*0.9).height
        facName = UILabel(frame: CGRect(x: scWid * 0.05, y:  hei, width: scWid*0.9, height: texthei))
        facName.text = self.facultyFullName
        facName.font = fm.setFontSizeLight(fs: 15)
        self.scoll.addSubview(facName)
        
        hei = facName.frame.height + facName.frame.origin.y
        texthei = fm.calculateHeiFromString(text: self.majorInformation.description,fontsize:fm.setFontSizeLight(fs: 12.5), tbWid : scWid * 0.86).height
        majorDescrip  = UITextView(frame: CGRect(x: scWid * 0.05, y: hei + 10, width: scWid*0.9, height: texthei))
        majorDescrip.font = fm.setFontSizeLight(fs: 14)
        majorDescrip.textAlignment = .left
        majorDescrip.isUserInteractionEnabled = false
        majorDescrip.text = "\(self.majorInformation.description as! String)"

        self.scoll.addSubview(majorDescrip)
        
        hei = majorDescrip.frame.height + majorDescrip.frame.origin.y + 20
        return hei + scWid*0.1

    }

}
