
import UIKit

class NewsTableViewController: UITableViewController {
    
    var allNewsList : [NewsModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        return 20
    }

    //action in each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Newscell", for: indexPath) as! NewsCell
//        var news = allNewsList[indexPath.row]
        //http://www.publicdomainpictures.net/pictures/40000/velka/white-daisy-flower.jpg
        
//        let url = NSURL(string:"www.publicdomainpictures.net/pictures/40000/velka/white-daisy-flower.jpg")
//        let data = NSData(contentsOf:url! as URL)
//        cell.newsImg.image = UIImage(data:data as! Data)
        
        if indexPath.row == 0 {
            cell.newsImg.backgroundColor = UIColor.brown
            cell.newsImg.frame = CGRect(x: 0, y: 0, width:scWid, height: scHei*0.4)
            cell.newsTitle.isHidden = true
            cell.newsSubtitle.isHidden = true
        } else {
            cell.newsImg.backgroundColor = UIColor.red
            cell.newsImg.frame = CGRect(x: scWid*0.035, y: scHei*0.0125, width: scWid*0.3, height: scHei*0.15)
            cell.newsTitle.frame = CGRect(x: scWid*0.361, y: scHei*0.0125, width: scWid*0.595, height: scHei*0.06)
            cell.newsTitle.backgroundColor = UIColor.black
            cell.newsSubtitle.frame = CGRect(x: scWid*0.361, y: scHei*0.0775, width: scWid*0.595, height: scHei*0.0575)
            cell.newsSubtitle.backgroundColor = UIColor.yellow
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
