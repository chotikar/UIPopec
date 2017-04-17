
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(urlStr:
        String) {
        
        if let cacheImage = imageCache.object(forKey: urlStr as AnyObject) as? UIImage{
            self.image = cacheImage
            return
        }
        
        let url = NSURL(string: urlStr)
        URLSession.shared.dataTask(with: url! as URL) {
            data, response, error in
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async {
                if let downloadImage = UIImage(data: data!) {
                    imageCache.setObject(downloadImage, forKey: urlStr as AnyObject)
                    self.image = downloadImage
                }
            }
            }.resume()
    }
}
