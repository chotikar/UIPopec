

import UIKit

class CurriculumSubCell: UITableViewCell {
    
    let CourseCode : UILabel = {
        let ct = UILabel()
        ct.translatesAutoresizingMaskIntoConstraints = false
        ct.font = FunctionMutual.setFontSizeBold(fs: 13)
        ct.textColor = UIColor.gray
        ct.text = "Course Title or Code"
        ct.textAlignment = .left
        return ct
    }()
    let CourseSubTitle : UILabel = {
       let cs = UILabel()
        cs.translatesAutoresizingMaskIntoConstraints = false
        cs.font = FunctionMutual.setFontSizeBold(fs: 15)
        cs.textColor = UIColor.darkText
        cs.text = "Course SubTitle"
        return cs
    }()
    let Credit : UILabel = {
       let c = UILabel()
        c.translatesAutoresizingMaskIntoConstraints = false
        c.font = FunctionMutual.setFontSizeBold(fs: 15)
        c.textColor = UIColor.darkText
        c.text = "3"
        c.backgroundColor = UIColor.clear
        c.textAlignment = .center
        return c
    }()
    let SeperateLine : UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.lightGray
        return line
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(CourseCode)
        self.contentView.addSubview(CourseSubTitle)
        self.contentView.addSubview(Credit)
        self.contentView.addSubview(SeperateLine)
    }
    
    override func layoutSubviews() {
        Credit.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        Credit.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        Credit.widthAnchor.constraint(equalToConstant: 20).isActive = true
        CourseSubTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        CourseSubTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        CourseSubTitle.rightAnchor.constraint(equalTo: Credit.leftAnchor, constant: -5).isActive = true
        Credit.leftAnchor.constraint(equalTo: CourseSubTitle.rightAnchor).isActive = true
        Credit.bottomAnchor.constraint(equalTo: CourseSubTitle.bottomAnchor).isActive = true
        CourseCode.topAnchor.constraint(equalTo: CourseSubTitle.bottomAnchor).isActive = true
        CourseCode.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        CourseCode.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        CourseCode.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        SeperateLine.topAnchor.constraint(equalTo: CourseCode.bottomAnchor).isActive = true
//        SeperateLine.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
//        SeperateLine.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
//        SeperateLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
//class CurriculumCell: UITableViewCell {
//   
//    let CourseTitle : UILabel = {
//        let cs = UILabel()
//        cs.translatesAutoresizingMaskIntoConstraints = false
//        cs.font = FunctionMutual.setFontSizeBold(fs: 15)
//        cs.textColor = UIColor.white
//        cs.text = "Course Title"
//        return cs
//    }()
//    let TotalCredit : UILabel = {
//        let c = UILabel()
//        c.translatesAutoresizingMaskIntoConstraints = false
//        c.font = FunctionMutual.setFontSizeBold(fs: 13)
//        c.textColor = UIColor.white
//        c.text = "48"
//        c.textAlignment = .left
//        return c
//    }()
//    
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.contentView.addSubview(CourseTitle)
//        self.contentView.addSubview(TotalCredit)
//        self.contentView.backgroundColor = appColor
//    }
//    
//    override func layoutSubviews() {
//        TotalCredit.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
//        TotalCredit.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
//        TotalCredit.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        CourseTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
//        CourseTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
//        CourseTitle.rightAnchor.constraint(equalTo: TotalCredit.leftAnchor, constant: -5).isActive = true
//        CourseTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        TotalCredit.leftAnchor.constraint(equalTo: CourseTitle.rightAnchor).isActive = true
//        TotalCredit.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//        
//    }
//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }
//    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
//    
//}
//
//
