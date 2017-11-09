
import UIKit
import SWRevealViewController
import SDWebImage

class NewsTableViewController: UITableViewController,SWRevealViewControllerDelegate {
    
    @IBOutlet weak var MenuButton: UIBarButtonItem!
    var allNewsList: [NewsModel]!
    let ws = WebService.self
    var newsList: [NewsModel] = []
    let cellId = "Newscell"
    var lang: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lang = CRUDSettingValue.GetUserSetting()
        self.title = lang == "E" ? "News" : "ข่าวสาร"
        reloadTableViewInNews(lang: lang)
        MenuButton.target = self.revealViewController()
        self.tableView.register(NewsCell, forCellReuseIdentifier: cellId)
        MenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        CustomNavbar()
    }
    
    // number of row
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsList.count
    }
    
    //action in each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! NewsCell
        let news = self.newsList[indexPath.row]
        if indexPath.row == 0 {
            cell.newsImg.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            cell.newsImg.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
            cell.newsImg.leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
            cell.newsImg.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
            cell.newsTitle.isHidden = true
            cell.newsSubtitle.isHidden = true
        } else {
            cell.newsImg.sd_setImage(with: NSURL(string: news.imageURL)! as URL, placeholderImage: UIImage(named:"abaccl"))
            cell.newsImg.frame = CGRect(x: scWid*0.035, y: scHei*0.0125, width: scWid*0.3, height: scHei*0.15)
            cell.newsTitle.frame = CGRect(x: scWid*0.361, y: scHei*0.0125, width: scWid*0.595, height: scHei*0.06)
            cell.newsSubtitle.frame = CGRect(x: scWid*0.361, y: scHei*0.0775, width: scWid*0.595, height: scHei*0.0575)
            cell.newsTitle.text = news.topic
            cell.newsSubtitle.text = news.description
            cell.newsTitle.isUserInteractionEnabled = false
            cell.newsSubtitle.isUserInteractionEnabled = false
        }
        return cell
    }
    
    // height of cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return scHei * 0.4
        }else{
            return scHei * 0.15
        }
    }
    
    // action when click each cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        var fnl :[NewsModel]!
        //        fnl.append(allNewsList[indexPath.row])
        //        let firstFac = allNewsList[indexPath.row]
        //        for c in allNewsList {
        //            if c == firstFac.source {
        //                fnl.append(c)
        //            }
        //        }
        let vc = storyboard?.instantiateViewController(withIdentifier: "NewsInformationLayout") as! NewsInforViewController
        vc.facNewsList = self.newsList
        vc.showNewsModel = self.newsList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func reloadTableViewInNews(lang:String){
        ws.GetNewsRequireWS(lastNewsId: 0, numberOfNews: 10 ,lang: lang) { (responseData: [NewsModel], nil) in
            DispatchQueue.main.async( execute: {
                self.newsList = responseData
                self.tableView.reloadData()
            })
        }
    }
    
    func CustomNavbar() {
        navigationController?.navigationBar.barTintColor = appColor
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
}

class NewsCell: UITableViewCell {
    let fm = FunctionMutual.self
    let newsImg : UIImageView = {
        let ni = UIImageView()
        ni.translatesAutoresizingMaskIntoConstraints = false
        ni.image = UIImage(named: "abaccl")
        return ni
    }()
    var newsTitle : UILabel = {
       let nt = UILabel()
        nt.translatesAutoresizingMaskIntoConstraints = false
        nt.textColor = UIColor.darkGray
        nt.textAlignment = .left
        nt.text = "Title"
        return nt
    }()
    var newsSubtitle : UITextView = {
        var ns = UITextView()
        ns.translatesAutoresizingMaskIntoConstraints = false
        ns.textColor = UIColor.black
        ns.textAlignment = .left
        ns.text = "Sub Title"
        return ns
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(newsImg)
        self.contentView.addSubview(newsTitle)
        self.contentView.addSubview(newsSubtitle)
    }
    
    override func layoutSubviews() {
        newsImg.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        newsImg.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -10).isActive = true
        newsImg.widthAnchor.constraint(equalToConstant: scHei * 0.15 * 1.2 ).isActive = true
        newsImg.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        newsTitle.font = fm.setFontSizeBold(fs: 14)
        newsTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        newsTitle.leftAnchor.constraint(equalTo: newsImg.rightAnchor, constant: 5).isActive = true
        newsTitle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        newsTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        newsSubtitle.font = fm.setFontSizeBold(fs: 13)
        newsSubtitle.topAnchor.constraint(equalTo: newsTitle.bottomAnchor).isActive = true
        newsSubtitle.leftAnchor.constraint(equalTo: newsImg.rightAnchor, constant: 5).isActive = true
        newsSubtitle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        newsSubtitle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}









//class NewsCell: UITableViewCell {
//    let fm = FunctionMutual.self
//     newsImg: UIImageView!
//    @IBOutlet weak var newsTitle: UITextView!
//    @IBOutlet weak var newsSubtitle: UITextView!
//
//    override func awakeFromNib() {
//        newsImg.image = UIImage(named: "abaccl")
//        newsTitle.textColor = UIColor.darkGray
//        newsTitle.font = fm.setFontSizeBold(fs: 14)
//        newsTitle.textAlignment = .left
//        newsTitle.text = "Title"
//        newsTitle.backgroundColor = UIColor.yellow
//        //        newsTitle.scrollsToTop = false
//        newsSubtitle.textColor = UIColor.black
//        newsSubtitle.font = fm.setFontSizeLight(fs: 13)
//        newsSubtitle.textAlignment = .left
//        newsSubtitle.text = "Sub Title"
//        newsSubtitle.backgroundColor = UIColor.red
//        //        newsSubtitle.scrollsToTop = false
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//}

