//
//  ImageServise.swift
//  MyVk
//
//  Created by Андрей Закусов on 19.01.2020.
//  Copyright © 2020 Закусов Андрей. All rights reserved.
//

import Foundation
import UIKit


class ImageServise{
    static let shared = ImageServise()
    private init(){}
    
    private let cacheLifeTime: TimeInterval = 1 * 60 * 60
    
    private static let pathName: String = {
        
        let pathName = "images"
        
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return pathName }
        let url = cachesDirectory.appendingPathComponent(pathName, isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        
        return pathName
    }()
    
    fileprivate var images = [String: UIImage]()
    
    
    private func getFilePath(url: String) -> String? {
        
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        
        let hashName = url.split(separator: "/").last ?? "default"
        return cachesDirectory.appendingPathComponent(ImageServise.pathName + "/" + hashName).path
    }
    
    private func saveImageToChache(url: String, image: UIImage) {
        guard let fileName = getFilePath(url: url) else { return }
        let data = image.pngData()
        FileManager.default.createFile(atPath: fileName, contents: data, attributes: nil)
    }
    
    fileprivate func getImageFromChache(url: String) -> UIImage? {
        guard
            let fileName = getFilePath(url: url),
            let info = try? FileManager.default.attributesOfItem(atPath: fileName),
            let modificationDate = info[FileAttributeKey.modificationDate] as? Date
            else { return nil }
        
        let lifeTime = Date().timeIntervalSince(modificationDate)
        
        guard
            lifeTime <= cacheLifeTime,
            let image = UIImage(contentsOfFile: fileName) else { return nil }
        
        images[url] = image
        return image
    }
    
    
    fileprivate func loadPhoto(imageCache: ImageCacheVK, webUrl: String) {
        DispatchQueue.global().async {
            let url = URL(string: webUrl)
            if let data = try? Data(contentsOf: url!)
            {
                let image = UIImage(data: data)
                self.images[webUrl] = image
                self.saveImageToChache(url: webUrl, image: image!)
                imageCache.image = image
            }
        }
    }

    
}

class ImageCacheVK{
    let imageView: UIImageView
    let url: String
    var image: UIImage?{
        didSet{
            DispatchQueue.main.async{
                self.imageView.image = self.image
                self.imageView.contentMode = .scaleAspectFit
            }
        }
    }
    
    let defaultImage = #imageLiteral(resourceName: "defaoltImage")
    
    init(imageView: UIImageView, url: String) {
        self.imageView = imageView
        self.url = url
        
        if let imageCache = ImageServise.shared.images[url] {
            self.image = imageCache
        } else if let imageCache = ImageServise.shared.getImageFromChache(url: url) {
            self.image = imageCache
        } else {
            self.image = defaultImage
            ImageServise.shared.loadPhoto(imageCache: self, webUrl: url)
        }
        
        self.imageView.image = image
        
    }
    
}
