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

    convenience init(foto: UIImage?) {
        self.init()
        self.foto = foto
    }
    
    convenience init(json: [String: Any]){
        self.init()
        self.Path130 = json["photo_130"] as! String
        self.Path604 = json["photo_604"] as! String
        
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
