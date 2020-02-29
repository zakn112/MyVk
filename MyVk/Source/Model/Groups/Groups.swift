//
//  Groups.swift
//  MyVk
//
//  Created by kio on 29/09/2019.
//  Copyright © 2019 kio. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class GroupRealm: Object{
    @objc dynamic var name:String = ""
    var photo:UIImage?
    @objc dynamic var id:Int = 0
    @objc dynamic var photo_50_str:String = ""
    @objc dynamic var photo_50_str_local:String = ""
    
    convenience init(json: [String: Any]) {
        self.init()
        
        id = json["id"] as! Int
        name = json["name"] as! String
        photo_50_str = json["photo_50"] as! String
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}
