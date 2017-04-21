
import UIKit
import SWRevealViewController

class NewsTableViewController: UITableViewController {
    
    @IBOutlet weak var MenuButton: UIBarButtonItem!
    var allNewsList : [NewsModel]!
    let ws = WebService.self
    var newsList : [NewsModel] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadTableViewInNews(lang: CRUDSettingValue.GetUserSetting())
        Sidemenu()
        CustomNavbar()  
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
//        var news = allNewsList[indexPath.row]
        //http://www.publicdomainpictures.net/pictures/40000/velka/white-daisy-flower.jpg
        
//        let url = NSURL(string:"www.publicdomainpictures.net/pictures/40000/velka/white-daisy-flower.jpg")
//        let data = NSData(contentsOf:url! as URL)
//        cell.newsImg.image = UIImage(data:data as! Data)
        let news = self.newsList[indexPath.row]
        if indexPath.row == 0 {
            cell.newsImg.frame = CGRect(x: 0, y: 0, width:scWid, height: scHei*0.4)
            cell.newsTitle.isHidden = true
            cell.newsSubtitle.isHidden = true
        } else {
//            cell.newsImg.image  = UIImage(named: "abacImg")
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
//            if c.source == firstFac.source {
//                fnl.append(c)
//            }
//        }
        
//        let vc = storyboard?.instantiateViewController(withIdentifier: "NewsInformationLayout") as! NewsInforViewController
//        vc.facNewsList = fnl
//        self.navigationController?.pushViewController(vc, animated: true)
   }
    
    func reloadTableViewInNews(lang:String){
        ws.GetNewsRequireWS(lastNewsId: 0, numberOfNews: 10 ,lang: lang) { (responseData: [NewsModel], nil) in
            DispatchQueue.main.async( execute: {
                self.newsList = responseData
                self.tableView.reloadData()
//                print(self.faclist)
            })
        }
    }
    
    
    func Sidemenu() {
        if revealViewController() != nil {
            MenuButton.target = SWRevealViewController()
            MenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
//        SWRevealViewControllerDelegate.revealControllerPanGestureShouldBegin(<#T##SWRevealViewControllerDelegate#>)
    }
    
    func CustomNavbar() {
        navigationController?.navigationBar.barTintColor = abacRed
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
    }

    
    
//    func loadImage (imgLink : String) -> UIImage {
//    
//        var url:URL = URL.fileURL(withPath: imgLink)
//        var data:NSData = NSData.init(contentsOf: url as URL, options: nil)//.dataWithContentsOfURL(url, options: nil, error: nil)
//        
//        return UIImage.imageWithData(data)
//    }
//    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class NewsCell: UITableViewCell {
    let fm = FunctionMutual.self
    @IBOutlet weak var newsImg: UIImageView!
    @IBOutlet weak var newsTitle: UITextView!
    @IBOutlet weak var newsSubtitle: UITextView!
    
    
    override func awakeFromNib() {
        newsImg.image = UIImage(named: "abacImg")
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
    //
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

