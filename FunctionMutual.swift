
import Foundation
import UIKit

class FunctionMutual {
    
    static func calculateHeiFromString(text:String, fontsize:UIFont, tbWid : CGFloat) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let option = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: option, attributes: [NSFontAttributeName:fontsize], context: nil)
    }
    
    static func setFontSizeLight(fs : CGFloat) -> UIFont {
        return UIFont(name: "Gidole-Regular", size: fs)!
    }
    
    static func setFontSizeBold(fs : CGFloat) -> UIFont {
        return UIFont(name: "Gidole-Regular", size: fs)!
    }
    
    static func getColorrgb(r:CGFloat , g : CGFloat, b: CGFloat,al : CGFloat) -> UIColor{
        return UIColor(displayP3Red: r/225, green: g/225, blue: b/225, alpha: al)
    }
    static func test(){
        
    }
}
