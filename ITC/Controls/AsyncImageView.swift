//
//  AsyncImageView.swift
//  ITC
//
//  Created by Harsha M G on 13/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//
import UIKit

class AsyncImageView: UIImageView {
    
    static let imageCache = NSCache<NSString, AnyObject>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadImage(from url: String) {
        
        image = UIImage(named: url)
        
//        image = #imageLiteral(resourceName: "picture")
        
        /*
        let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let imageURL = URL(string: encodedURL!)
        
        // Loading image from cache
        if let cachedImage = AsyncImageView.imageCache.object(forKey: url as NSString) as? UIImage {
            
            image = cachedImage
            return
        }
        
        URLSession.shared.dataTask(with: imageURL!) { (data, response, error) in
            
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            
            let image = UIImage(data: data!)
            AsyncImageView.imageCache.setObject(image!, forKey: url as NSString)
            DispatchQueue.main.async {
                self.image = image!
            }
            }.resume()
 */
    }
    
}
