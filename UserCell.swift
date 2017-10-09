
import Foundation
import UIKit

class UserCell : UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x:  56, y: (textLabel!.frame.origin.y - 2), width: (textLabel!.frame.width), height: (textLabel!.frame.height))
        detailTextLabel?.frame = CGRect(x: 56, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    var profileImageView : UIImageView = {
        var piv = UIImageView()
        piv.image = UIImage(named: "User_Shield")
        piv.contentMode = .scaleAspectFill
        piv.translatesAutoresizingMaskIntoConstraints = false
        piv.layer.cornerRadius = 20
        piv.layer.masksToBounds = true
        return piv
    }()
    
    var timeLable: UILabel = {
        var label = UILabel()
        label.text = "HH:MM:SS"
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var title: UILabel = {
        var ti = UILabel()
        ti.text = "Department name"
        ti.font = UIFont.systemFont(ofSize: 15)
        ti.textColor = UIColor.darkText
        ti.translatesAutoresizingMaskIntoConstraints = false
        return ti
    }()
    
    var message : UILabel = {
        var mess = UILabel()
        mess.text = "Message"
        mess.font = UIFont.systemFont(ofSize: 13)
        mess.textColor = UIColor.gray
        mess.translatesAutoresizingMaskIntoConstraints = false
        return mess
    }()
    
    let unreadNumber: UILabel = {
        let nn = UILabel()
        nn.textColor = UIColor.white
        nn.backgroundColor = UIColor.red
        nn.font = FunctionMutual.setFontSizeLight(fs: 13)
        nn.translatesAutoresizingMaskIntoConstraints = false
        nn.layer.masksToBounds = true
        nn.layer.cornerRadius = 8
        nn.layer.masksToBounds = true
        nn.textAlignment = NSTextAlignment.center
        return nn
    }()
    
    var unreadWidthAnchor: NSLayoutConstraint?
    
    override init(style: UITableViewCellStyle, reuseIdentifier:String?){
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        addSubview(timeLable)
        addSubview(title)
        addSubview(message)
        addSubview(unreadNumber)
        
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        timeLable.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -8).isActive = true
        timeLable.topAnchor.constraint(equalTo: self.profileImageView.topAnchor).isActive = true
        timeLable.widthAnchor.constraint(equalToConstant: 60).isActive = true
        timeLable.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        
        title.topAnchor.constraint(equalTo: self.timeLable.topAnchor, constant: 5).isActive = true
        title.leftAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: 8).isActive = true
        title.rightAnchor.constraint(equalTo: self.timeLable.leftAnchor).isActive = true
        title.heightAnchor.constraint(equalTo: title.heightAnchor).isActive = true

        unreadNumber.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        unreadWidthAnchor = unreadNumber.widthAnchor.constraint(equalToConstant: 0)
        unreadWidthAnchor?.isActive = true
        unreadNumber.heightAnchor.constraint(equalTo: unreadNumber.heightAnchor).isActive = true
        unreadNumber.bottomAnchor.constraint(equalTo: message.bottomAnchor).isActive = true
        
        message.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -5).isActive = true
        message.leftAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: 8).isActive = true
        message.rightAnchor.constraint(equalTo: self.unreadNumber.leftAnchor, constant: -5).isActive = true
        message.heightAnchor.constraint(equalTo: message.heightAnchor).isActive = true
        
    }
    
    required init?(coder aDecorder : NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



















//class UserCell : UITableViewCell {

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
//        addSubview(textLabel!)
//        addSubview(detailTextLabel!)
//        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
//        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
//    }
//    
//    required init?(coder aDecorder : NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    let picUser : UIImageView = {
//       let pu = UIImageView()
//        pu.frame = CGRect(x: 0, y:0, width: scWid*0.3, height: scWid*0.3)
//        pu.image = UIImage(named: "User_Shield")
//    
//        return pu
//    }()
//    
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
