
import Foundation
import UIKit
import SystemConfiguration

class FunctionMutual {
    
    static func calculateHeiFromString(text: String, fontsize: CGFloat, tbWid: CGFloat) -> CGRect {
        let size = CGSize(width: tbWid, height: 1000)
        let option = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: option, attributes: [NSFontAttributeName: UIFont(name: "Gidole-Regular", size: fontsize)], context: nil)
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
    static func toast(message : String) -> UIView {
        let toastSize = calculateHeiFromString(text: message, fontsize: 13, tbWid: 200)
        let toastBox = UIView(frame: CGRect(x: (scWid-(toastSize.width + 20))/2, y: scHei-(toastSize.height+100), width: toastSize.width+40, height: toastSize.height+20))
        let textfiled = UILabel(frame: CGRect(x: 20, y:10, width: toastSize.width, height: toastSize.height))
        toastBox.backgroundColor = UIColor.gray
        toastBox.layer.cornerRadius = 18
        toastBox.alpha = 0.9
        textfiled.textColor = UIColor.white
        textfiled.textAlignment = .center
        textfiled.font = setFontSizeLight(fs: 13)
        textfiled.text = message
        toastBox.addSubview(textfiled)
        return toastBox
    }
    
    static func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    static func callByNumber(phoneNumber: String) {
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    static func email(email: String) {
        
    }
}


