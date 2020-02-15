//
//  Photos.swift
//  MyVk
//
//  Created by kio on 08/10/2019.
//  Copyright © 2019 kio. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class PhotoVK: Object{
    var foto:UIImage?
    @objc dynamic var likeNumber:Int = 0
    @objc dynamic var Path130:String = ""
    @objc dynamic var Path604:String = ""
    @objc dynamic var Path130Local:String = ""
    @objc dynamic var Path604Local:String = ""
    @objc dynamic var User: UserVK?
    var width: Int = 0
    var height: Int = 0
    var aspectRatio: CGFloat { return CGFloat(height)/CGFloat(width) }


    convenience init(foto: UIImage?) {
        self.init()
        self.foto = foto
    }
    
    convenience init(json: [String: Any]){
        self.init()
        self.Path130 = json["photo_130"] as! String
        self.Path604 = json["photo_604"] as! String
        
        self.width = json["width"] as? Int ?? 0
        self.height = json["height"] as? Int ?? 0
        
//        let url = URL(string: json["photo_130"] as! String)
//        if let data = try? Data(contentsOf: url!)
//        {
//            self.foto = UIImage(data: data)
//        }
    }
    
    override class func primaryKey() -> String? {
        return "Path130"
    }
}

class PhotoVK_ {
    var Path604:String = ""
    var likeNumber:Int = 0
    var Path130:String = ""
    var Path130Local:String = ""
    var Path604Local:String = ""
    var text:String = ""
    var date:Date = Date.init()
    
    var width: Int = 0
    var height: Int = 0
    var aspectRatio: CGFloat { return CGFloat(height)/CGFloat(width) }


    init(photoVK: PhotoVK) {
        
        self.Path604 = photoVK.Path604
        self.width = photoVK.width
        self.height = photoVK.height
    }
   
    init(json: [String: Any]){
        self.Path604 = json["photo_604"] as! String
        self.text = json["text"] as! String
        self.date = json["date"] as? Date ?? Date.init()
        
        self.width = json["width"] as? Int ?? 0
        self.height = json["height"] as? Int ?? 0
        
    }
   
}
