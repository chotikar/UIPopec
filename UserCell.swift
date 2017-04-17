
import Foundation
import UIKit

//class UserCell : UITableViewCell {
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        textLabel?.frame = CGRect(x:  56, y: (textLabel!.frame.origin.y - 2), width: (textLabel!.frame.width), height: (textLabel!.frame.height))
//        detailTextLabel?.frame = CGRect(x: 56, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
//    }
//    
//    let profileImageView : UIImageView = {
//        let piv = UIImageView()
//        piv.image = (UIImage(named: "User_Shield"))
//        piv.contentMode = .scaleAspectFill
//        piv.translatesAutoresizingMaskIntoConstraints = false
//        piv.layer.cornerRadius = 20
//        piv.layer.masksToBounds = true
//        piv.backgroundColor = UIColor.brown
//        return piv
//    }()
//    
//    override init(style: UITableViewCellStyle, reuseIdentifier:String?){
//        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
//        addSubview(profileImageView)
//        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
//        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//    profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
//    }
//    
//    required init?(coder aDecorder : NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

//    let picUser : UIImageView = {
//       let pu = UIImageView()
//        pu.frame = CGRect(x: 0, y:0, width: sWid*0.3, height: sWid*0.3)
//        pu.image = UIImage(cgImage: "User_Shield" as! CGImage)
//    
//        return pu
//    }()
    
//    let titleLabel: UITextView = {
//        let tl = UITextView()
//        tl.font = UIFont.systemFont(ofSize: 16)
//        tl.textColor = UIColor.black
//        tl.textAlignment = .left
//       return tl
//    }()
//    
//    let subtitleLabel : UITextView = {
//       let sl = UITextView()
//        sl.font = UIFont.systemFont(ofSize: 12)
//        sl.textColor = UIColor.black
//        sl.textAlignment = .left
//        return sl
//    }()
    
//}
