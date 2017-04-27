
import UIKit
import Foundation

class ChatMessageCell: UICollectionViewCell{
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = FunctionMutual.setFontSizeLight(fs: 14)
        tv.text = "CHAT Message Log"
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.isEditable = false
        return tv
    }()
    
    static let blueColor = UIColor(red: 0/225, green: 137/225, blue: 249/225, alpha: 1)
    
    let bubbleView: UIView = {
        let view = UIView()
        //        view.backgroundColor = UIColor(red: 25, green: 152, blue: 246, alpha: 1)
        view.backgroundColor = blueColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 13
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView : UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "User_Shield")
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 16
        img.layer.masksToBounds = true
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    let chatTime : UILabel = {
       let ct = UILabel()
        ct.textColor = UIColor.lightGray
        ct.font = FunctionMutual.setFontSizeLight(fs: 10)
        return ct
    }()
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleRightAnchor: NSLayoutConstraint?
    var bubbleLeftAnchor: NSLayoutConstraint?
    var timeRight : NSLayoutConstraint?
    var timeLeft : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageView)
        addSubview(chatTime)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor,constant:8).isActive = true
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        bubbleRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor,constant:-16)
        bubbleRightAnchor?.isActive = true
        bubbleLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor,constant:5)
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        bubbleWidthAnchor =  bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor,constant:-4).isActive = true
        
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor,constant:8).isActive = true
        textView.topAnchor.constraint(equalTo: bubbleView.topAnchor,constant:8).isActive = true
        textView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor,constant:-16).isActive = true
        textView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        
        timeRight = chatTime.rightAnchor.constraint(equalTo: bubbleView.leftAnchor,constant : 3)
        timeLeft = chatTime.leftAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: 3)
        chatTime.widthAnchor.constraint(equalToConstant: 70).isActive = true
        timeLeft?.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ChatLogTableViewCell : UITableViewCell {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = FunctionMutual.setFontSizeLight(fs: 14)
        tv.text = "CHAT Message Log"
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.isEditable = false
        return tv
    }()
    
    static let blueColor = UIColor(red: 0/225, green: 137/225, blue: 249/225, alpha: 1)
    
    let bubbleView: UIView = {
        let view = UIView()
        //        view.backgroundColor = UIColor(red: 25, green: 152, blue: 246, alpha: 1)
        view.backgroundColor = blueColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView : UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "User_Shield")
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 16
        img.layer.masksToBounds = true
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    let chatTime : UILabel = {
        let ct = UILabel()
        ct.textColor = UIColor.lightGray
        ct.font = FunctionMutual.setFontSizeLight(fs: 10)
        ct.translatesAutoresizingMaskIntoConstraints = false
        return ct
    }()

    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleRightAnchor: NSLayoutConstraint?
    var bubbleLeftAnchor: NSLayoutConstraint?
    var timeRight : NSLayoutConstraint?
    var timeLeft : NSLayoutConstraint?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageView)
        addSubview(chatTime)
        
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor,constant:8).isActive = true
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        bubbleRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor,constant:-16)
        bubbleRightAnchor?.isActive = true
        bubbleLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor,constant:4)
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        bubbleWidthAnchor =  bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor,constant:-4).isActive = true
        
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor,constant:8).isActive = true
        textView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        textView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor,constant:-16).isActive = true
        textView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        
        timeRight = chatTime.rightAnchor.constraint(equalTo: bubbleView.leftAnchor,constant : -3)
        timeLeft = chatTime.leftAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: 3)
        chatTime.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor).isActive = true
        chatTime.widthAnchor.constraint(equalToConstant: 50).isActive = true
        timeLeft?.isActive = true
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

