import UIKit

class ImageCache {
    static let shared = ImageCache()
    private var cache = NSCache<NSString, UIImage>()
    
    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func save(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func loadImage(fromURL imageURL: URL, forImageView imageView:UIImageView) {
        if let cachedImage = ImageCache.shared.image(forKey: imageURL.absoluteString) {
            imageView.image = cachedImage
            return
        }
        
        let task = URLSession.shared.dataTask(with: imageURL) {
            (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                ImageCache.shared.save(image: image, forKey: imageURL.absoluteString)
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }
        task.resume()
    }
}


