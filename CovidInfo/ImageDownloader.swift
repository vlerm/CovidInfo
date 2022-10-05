//
//  ImageDownloader.swift
//  CovidInfo
//
//  Created by Вадим Лавор on 5.10.22.
//

import UIKit

class ImageDownloader {
    
    var imageCache: [String: UIImage] = [:]
    
    func getImage(imageUrl: String?, size: CGSize, completion: @escaping (UIImage?) -> Void) {
        guard let stringImageUrl = imageUrl, let url = URL(string: stringImageUrl)
        else {
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }
        let urlKey = url.key(size: size)
        if let imageCached = imageCache.cached(urlKey) {
            DispatchQueue.main.async {
                completion(imageCached)
            }
            return
        }
        DispatchQueue.global().async { [weak self] in
            guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            let imageResized = image.resized(size: size)
            DispatchQueue.main.async { [weak self] in
                self?.imageCache.cache(key: urlKey, value: imageResized)
                completion(imageResized)
            }
        }
    }
    
}

private extension Dictionary where Key == String {
    
    func cached(_ key: String) -> UIImage? {
        return self[key] as? UIImage
    }
    
    mutating func cache(key: String, value: Value?) {
        self[key] = value
    }
    
}

private extension UIImage {
    
    func resized(size: CGSize) -> UIImage? {
        let graphicsImageRenderer = UIGraphicsImageRenderer(size: size)
        let image = self
        return graphicsImageRenderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
}

private extension URL {
    
    func key(size: CGSize) -> String {
        return "\(absoluteString)-\(size.width)-\(size.height)"
    }
    
}
