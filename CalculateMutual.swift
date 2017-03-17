
import Foundation
import UIKit

class CalculateMutual {
    
    static func calculateHeiFromString(text:String, fontsize:UIFont, tbWid : CGFloat) -> CGRect {
        let size = CGSize(width: tbWid, height: 1000)
        let option = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: option, attributes: [NSFontAttributeName:fontsize], context: nil)
    }
    
}
