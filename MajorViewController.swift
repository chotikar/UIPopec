

import UIKit

class MajorViewController: UIViewController {

    var majorInformation = MajorModel()
    var facCode : Int!
    var majorCode : Int!
    var facultyFullName : String!
    let cm = CalculateMutual.self
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
        reloadMajor(facId: facCode, majorId: majorCode)
        self.view.addSubview(scoll)
        scoll.backgroundColor = UIColor.red
        // scoll.contentSize(drawMajorInformation())

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadMajor(facId : Int, majorId : Int) {
        ws.GetMajorDetailWS(facultyId: facId, departmentId: majorId){ (responseData: MajorModel, nil) in
            DispatchQueue.main.async( execute: {
                self.majorInformation = responseData
                self.reloadInputViews()
                self.reloadInputViews()
                print(self.majorInformation.departmentNameEn)
                print(self.majorInformation.descriptionTh)
                print(self.majorInformation.departmentId)
                self.scoll.contentSize = CGSize(width: scWid, height: self.drawMajorInformation())
            })
        }
    }
    

    func drawMajorInformation() ->CGFloat {
        var hei : CGFloat
        print(facultyFullName)
        majorImage = UIImageView(frame: CGRect(x: 0, y: scWid * 0.05, width: scWid, height: scWid*0.7))
        majorImage.backgroundColor = UIColor.yellow
        self.scoll.addSubview(majorImage)
        
        var texthei = cm.calculateHeiFromString(text: self.majorInformation.departmentNameEn,fontsize: UIFont.boldSystemFont(ofSize: 16), tbWid :scWid * 0.9 ).height
        majorTitle = UILabel(frame: CGRect(x: scWid * 0.05, y: scWid * 0.8, width: scWid * 0.9, height: texthei))
        majorTitle.text = self.majorInformation.departmentNameEn
        majorTitle.font = UIFont.boldSystemFont(ofSize: 16)
        self.scoll.addSubview(majorTitle)
        
        hei = majorTitle.frame.origin.y + majorTitle.frame.height
        texthei = cm.calculateHeiFromString(text: self.facultyFullName,fontsize: UIFont.systemFont(ofSize: 14), tbWid : scWid*0.9).height
        facName = UILabel(frame: CGRect(x: scWid * 0.05, y:  hei, width: scWid*0.9, height: texthei))
        facName.text = self.facultyFullName
        facName.font = UIFont.systemFont(ofSize: 15)
        self.scoll.addSubview(facName)
        
        hei = facName.frame.height + facName.frame.origin.y+10
        texthei = cm.calculateHeiFromString(text: self.majorInformation.descriptionTh,fontsize: UIFont.systemFont(ofSize: 12), tbWid : scWid * 0.86).height + 40
        print("MessageBoxSize : \(texthei)")
        majorDescrip  = UITextView(frame: CGRect(x: scWid * 0.07, y: hei, width: scWid*0.86, height: texthei))
        majorDescrip.font = UIFont.systemFont(ofSize: 12)
        majorDescrip.textAlignment = .center
        majorDescrip.isUserInteractionEnabled = false
        majorDescrip.text = self.majorInformation.descriptionTh
        self.scoll.addSubview(majorDescrip)
        
        hei = majorDescrip.frame.height + majorDescrip.frame.origin.y + 20
        return hei + scWid*0.1

    }

}
