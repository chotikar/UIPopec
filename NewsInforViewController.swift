import UIKit
import Foundation
import SDWebImage

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
    var scollSuggestNews : UIScrollView!
    var suggestNews1 : UIView!
    var suggestNews1Title : UILabel!
    var suggestNews2 : UIView!
    var suggestNews2Title : UILabel!
    var suggestNews3 : UIView!
    var suggestNews3Title : UILabel!
    var newssugestiontitle : String = ""
    var facNewsList : [NewsModel]!
    var showNewsModel : NewsModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SuggestionNewsCollection.delegate = self
        self.SuggestionNewsCollection.dataSource = self
        self.view.addSubview(scoll)
        self.view.addSubview(SuggestionNewsCollection)
        //        if facNewsList.count == 0 || facNewsList == nil {
        //            SuggestionNewsCollection.isHidden = true
        //        }
        //        self.scoll.frame = CGRect(x: 0, y: 0, width: scWid, height: scHei)
        setcv(contentSize: drawNewsInformation())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setcv(contentSize : CGFloat){
        self.SuggestionNewsCollection.frame = CGRect(x: scWid*0.05, y: contentSize, width: scWid*0.95, height: scHei*0.2)
        self.scoll.addSubview(self.SuggestionNewsCollection)
        self.scoll.contentSize = CGSize(width: scWid, height: contentSize+scHei*0.2)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.SuggestionNewsCollection.collectionViewLayout = layout
    }
    
    // draw News Infromation layout
    func drawNewsInformation() -> CGFloat {
        var heiCon = self.view.frame.origin.y
        mainImage = UIImageView(frame: CGRect(x: 0, y: heiCon, width: scWid, height: scWid*0.8))
        mainImage.sd_setImage(with: NSURL(string: showNewsModel.imageURL)! as URL, placeholderImage: UIImage(named:"abaccl"))
        self.scoll.addSubview(mainImage)
        heiCon = heiCon + mainImage.frame.height + 20
        
        var containHei = fm.calculateHeiFromString(text: showNewsModel.topic, fontsize: 16, tbWid: scWid * 0.9)
        newsTitle = UILabel(frame: CGRect(x: scWid * 0.05, y: heiCon, width: scWid * 0.9, height: containHei.height))
        newsTitle.text = showNewsModel.topic
        self.scoll.addSubview(newsTitle)
        heiCon = heiCon + newsTitle.frame.height
        
        containHei = fm.calculateHeiFromString(text: showNewsModel.typeName, fontsize: 16, tbWid: scWid * 0.9)
        newsSubtitle = UILabel(frame: CGRect(x: scWid * 0.07, y: heiCon, width: scWid*0.86, height: scWid*0.1))
        newsSubtitle.text = showNewsModel.typeName
        self.scoll.addSubview(newsSubtitle)
        heiCon = heiCon + newsSubtitle.frame.height
        
        containHei = fm.calculateHeiFromString(text: showNewsModel.description, fontsize: 12, tbWid: scWid * 0.9)
        news = UITextView(frame: CGRect(x: scWid * 0.07, y: heiCon, width: scWid*0.86, height: containHei.height+20))
        news.font = UIFont.systemFont(ofSize: 13)
        news.text = showNewsModel.description
        news.isUserInteractionEnabled = false
        self.scoll.addSubview(news)
        heiCon = heiCon + news.frame.height
        
        return heiCon + 50
    }
    
    ////** Collection view setting
    
    //number of row
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        if facNewsList.count < 5 {
        //            return 0
        //        }
        //        return facNewsList.count-1
        return facNewsList.count
    }
    
    //action each cell in collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "suggestionNewsItem", for: indexPath) as! SuggestionNewsCell
        cell.sugNewsImg.frame = CGRect(x: scHei*0.005, y: scHei*0.01, width: scHei*0.19, height: scHei*0.1)
        cell.sugNewsImg.image = UIImage(named:"abacImg")
        cell.sugNewsTitle.frame = CGRect(x: scHei*0.005, y: scHei*0.115, width: scHei*0.19, height: scHei*0.08)
        cell.sugNewsTitle.textColor = UIColor.darkText
        //        cell.sugNewsTitle.text = facNewsList[indexPath.row+1].topic
        cell.sugNewsTitle.text = facNewsList[indexPath.row].topic
        cell.sugNewsTitle.contentMode = UIViewContentMode.top
        cell.sugNewsTitle.font = UIFont.boldSystemFont(ofSize: 10)
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
}

class SuggestionNewsCell : UICollectionViewCell {
    @IBOutlet var sugNewsImg : UIImageView!
    @IBOutlet var sugNewsTitle : UILabel!
    
}

