
import UIKit
import ActiveLabel

class ChatLogCell: UICollectionViewCell {
    
    let textView: ActiveLabel = {
        let tv = ActiveLabel()
        tv.font = FunctionMutual.setFontSizeLight(fs: 13)
        tv.text = "message log"
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.red
        tv.sizeToFit()
        tv.layer.masksToBounds = false
        tv.textAlignment = .justified
        tv.urlMaximumLength = 50
        tv.numberOfLines = 0
        tv.lineSpacing = 0
        tv.hashtagFacColor = UIColor.lightGray
        tv.hashtagProColor = UIColor.lightGray
        tv.URLColor = UIColor.lightGray
        tv.hashtagProSelectedColor = UIColor.white
        tv.hashtagFacSelectedColor = UIColor.white
        tv.URLSelectedColor = UIColor.white //UIColor(red: 82.0/255, green: 190.0/255, blue: 41.0/255, alpha: 1)
        return tv
    }()
    
    static let blueColor = UIColor(red: 0/225, green: 137/225, blue: 249/225, alpha: 1)
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = blueColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 11
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "User_Shield")
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 16
        img.layer.masksToBounds = true
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    let chatTime: UITextView = {
        let ct = UITextView()
        ct.textColor = UIColor.lightGray
        ct.font = FunctionMutual.setFontSizeLight(fs: 10)
        ct.translatesAutoresizingMaskIntoConstraints = false
        ct.layer.masksToBounds = true
        return ct
    }()
    
    let readSatus: UITextView = {
        let ct = UITextView()
        ct.textColor = UIColor.lightGray
        ct.font = FunctionMutual.setFontSizeLight(fs: 10)
        ct.translatesAutoresizingMaskIntoConstraints = false
        ct.layer.masksToBounds = true
        return ct
    }()
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleRightAnchor: NSLayoutConstraint?
    var bubbleLeftAnchor: NSLayoutConstraint?
    var timeRight: NSLayoutConstraint?
    var timeLeft: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageView)
        addSubview(chatTime)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor,constant:7).isActive = true
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        bubbleRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor,constant:-7)
        bubbleRightAnchor?.isActive = true
        bubbleLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor,constant:7)
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        textView.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        textView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
//        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor,constant:5).isActive = true
//        textView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        textView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor, constant : -10).isActive = true
        textView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor, constant : -10).isActive = true
        
        timeRight = chatTime.rightAnchor.constraint(equalTo: bubbleView.leftAnchor,constant : -3)
        timeLeft = chatTime.leftAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: 3)
        chatTime.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor).isActive = true
        chatTime.widthAnchor.constraint(equalToConstant: 50).isActive = true
        timeLeft?.isActive = true
        chatTime.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

