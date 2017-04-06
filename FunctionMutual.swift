
import Foundation
import UIKit

class FunctionMutual {
    
    static func calculateHeiFromString(text:String, fontsize:UIFont, tbWid : CGFloat) -> CGRect {
        let size = CGSize(width: tbWid, height: 1000)
        let option = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: option, attributes: [NSFontAttributeName:fontsize], context: nil)
    }
    
    static func setFontSizeLight(fs : CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Light", size: fs)!
    }
    
    static func setFontSizeBold(fs : CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Bold", size: fs)!
    }
    
}
