
import UIKit
import Foundation

class NewsInforViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    let fm  = FunctionMutual.self
    let scoll : UIScrollView = {
        var sc = UIScrollView()
        sc.frame = CGRect(x: 0, y: 0, width: scWid, height: scHei)
        return sc
    }()
    @IBOutlet var SuggestionNewsCollection: UICollectionView!
    var mainImage : UIImageView!
    var newsTitle : UILabel!
    var newsSubtitle : UILabel!
    var location : UIView!
    var news : UITextView!

    var testBox :UIView = {
        var vb = UIView()
        vb.frame = CGRect(x: 0, y: 0, width: scHei*0.05, height: scHei*0.07)
        vb.backgroundColor = UIColor.yellow
        return vb
    }()
    var scollSuggestNews : UIScrollView!
    var suggestNews1 : UIView!
    var suggestNews1Title : UILabel!
    var suggestNews2 : UIView!
    var suggestNews2Title : UILabel!
    var suggestNews3 : UIView!
    var suggestNews3Title : UILabel!
    
    var newssugestiontitle : String = ""
    
    var facNewsList : [NewsModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SuggestionNewsCollection.delegate = self
        self.SuggestionNewsCollection.dataSource = self
        self.view.addSubview(scoll)
        self.view.addSubview(SuggestionNewsCollection)
//        self.scoll.frame = CGRect(x: 0, y: 0, width: scWid, height: scHei)
        scoll.backgroundColor = UIColor.blue
        setcv(contentSize: drawNewsInformation())
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setcv(contentSize : CGFloat){
        self.SuggestionNewsCollection.frame = CGRect(x: scWid*0.05, y: contentSize, width: scWid*0.95, height: scHei*0.2)
        self.SuggestionNewsCollection.backgroundColor = UIColor.red
        self.scoll.addSubview(self.SuggestionNewsCollection)
        self.scoll.contentSize = CGSize(width: scWid, height: contentSize+scHei*0.2)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.SuggestionNewsCollection.collectionViewLayout = layout

    }
    
    
    var containHei : CGFloat = 0
    
    // draw News Infromation layout
    func drawNewsInformation() -> CGFloat {
        var heiCon : CGFloat = 0
        mainImage = UIImageView(frame: CGRect(x: 0, y: scWid * 0.05, width: scWid, height: scWid*0.7))
        mainImage.backgroundColor = UIColor.yellow
        self.scoll.addSubview(mainImage)
        newsTitle = UILabel(frame: CGRect(x: scWid * 0.05, y: scWid * 0.8, width: scWid * 0.9, height: scWid * 0.1))
        newsTitle.backgroundColor = UIColor.brown
        self.scoll.addSubview(newsTitle)
        
        newsSubtitle = UILabel(frame: CGRect(x: scWid * 0.07, y: scWid*0.92, width: scWid*0.86, height: scWid*0.1))
        newsSubtitle.backgroundColor = UIColor.purple
        self.scoll.addSubview(newsSubtitle)
        
        location = UIView(frame: CGRect(x: scWid * 0.37, y: scWid*1.04, width: scWid*0.54, height: scWid*0.1))
        self.scoll.addSubview(location)
        let loIcon =  UIImageView(frame: CGRect(x: 0, y: 0, width: scWid*0.1, height: scWid*0.1))
        loIcon.backgroundColor = UIColor.yellow
        loIcon.image = UIImage(named: "locationnoGray")
        self.location.addSubview(loIcon)
        let loDef =  UIView(frame: CGRect(x: scWid*0.12, y: 0, width: location.bounds.width - (scWid*0.1), height: scWid*0.1))
        loDef.backgroundColor = UIColor.gray
        self.location.addSubview(loDef)
        
        news = UITextView(frame: CGRect(x: scWid * 0.07, y: scWid*1.16, width: scWid*0.86, height: scWid*0.1))
        news.font = UIFont.systemFont(ofSize: 13)
        news.backgroundColor = UIColor.green
        self.scoll.addSubview(news)
         return (self.news.frame.origin.y + self.news.frame.height + scWid*0.1)
//         (self.news.frame.origin.y + self.news.frame.height + scWid*0.1 + (self.navigationController?.navigationBar.frame.height)!) 
        
    }
    
    
    ////** Collection view setting
    
    //number of row
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10//facNewsList.count-1
    }
    
    //action each cell in collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "suggestionNewsItem", for: indexPath) as! SuggestionNewsCell
        cell.sugNewsImg.frame = CGRect(x: scHei*0.005, y: scHei*0.01, width: scHei*0.19, height: scHei*0.1)
        cell.sugNewsImg.backgroundColor = UIColor.brown
        cell.sugNewsTitle.frame = CGRect(x: scHei*0.005, y: scHei*0.115, width: scHei*0.19, height: scHei*0.08)
        cell.sugNewsTitle.textColor = UIColor.white
        cell.sugNewsTitle.text = ""
        cell.sugNewsTitle.contentMode = UIViewContentMode.top
        cell.sugNewsTitle.font = UIFont.boldSystemFont(ofSize: 10)
        cell.sugNewsTitle.backgroundColor = UIColor.blue
        return cell
    }
    
    //with and height of cell
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.frame.size = CGSize(width: scHei*0.2, height: scHei*0.2)
        cell.backgroundColor = UIColor.yellow
    }
    
    //width and height of space in each cell
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        return  CGSize(width: scHei*0.2, height: scHei*0.2)
    }
    
    /// enatimata height of box from string and size of string
    private func estimateFrameForText(text:String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 13)], context: nil)
    }
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class SuggestionNewsCell : UICollectionViewCell {
    
    @IBOutlet var sugNewsImg : UIImageView!
    @IBOutlet var sugNewsTitle : UILabel!
    
}

