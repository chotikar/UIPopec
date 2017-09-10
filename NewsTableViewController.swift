
import UIKit
import SWRevealViewController
import SDWebImage

class NewsTableViewController: UITableViewController,SWRevealViewControllerDelegate {
    
    @IBOutlet weak var MenuButton: UIBarButtonItem!
    var allNewsList : [NewsModel]!
    let ws = WebService.self
    var newsList : [NewsModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadTableViewInNews(lang: CRUDSettingValue.GetUserSetting())
        MenuButton.target = self.revealViewController()
        MenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        CustomNavbar()
    }
    
    //number of section in each row
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // number of row
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsList.count
    }
    
    //action in each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Newscell", for: indexPath) as! NewsCell
        let news = self.newsList[indexPath.row]
        if indexPath.row == 0 {
            cell.newsImg.frame = CGRect(x: 0, y: 0, width:scWid, height: scHei*0.4)
            cell.newsTitle.isHidden = true
            cell.newsSubtitle.isHidden = true
        } else {
            //            cell.newsImg.image  = UIImage(named: "abaccl")
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
            return scHei * 0.175
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
        navigationController?.navigationBar.barTintColor = abacRed
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
}

class NewsCell: UITableViewCell {
    let fm = FunctionMutual.self
    @IBOutlet weak var newsImg: UIImageView!
    @IBOutlet weak var newsTitle: UITextView!
    @IBOutlet weak var newsSubtitle: UITextView!
    
    override func awakeFromNib() {
        newsImg.image = UIImage(named: "abaccl")
        newsTitle.textColor = UIColor.darkGray
        newsTitle.font = fm.setFontSizeBold(fs: 14)
        newsTitle.textAlignment = .left
        newsTitle.text = "Title"
        //        newsTitle.scrollsToTop = false
        newsSubtitle.textColor = UIColor.black
        newsSubtitle.font = fm.setFontSizeLight(fs: 13)
        newsSubtitle.textAlignment = .left
        newsSubtitle.text = "Sub Title"
        //        newsSubtitle.scrollsToTop = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
