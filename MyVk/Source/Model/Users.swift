//
//  Users.swift
//  MyVk
//
//  Created by kio on 29/09/2019.
//  Copyright © 2019 kio. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class UserVK: Object {
    //new var
    @objc dynamic var name:String = ""
    //@objc dynamic var photos = [photoVK]()
    @objc dynamic var id:Int = 0
    @objc dynamic var first_name:String = ""
    @objc dynamic var last_name:String = ""
    @objc dynamic var photo_50_str:String = ""
    @objc dynamic var photo_50_str_local:String = ""
    
    convenience init(json: [String: Any]){
        self.init()
        id = json["id"] as! Int
        first_name = json["first_name"] as! String
        last_name = json["last_name"] as! String
        name = self.last_name + " " + self.first_name
        photo_50_str = json["photo_50"] as! String
 
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}


