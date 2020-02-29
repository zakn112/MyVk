//
//  DBRealm.swift
//  MyVk
//
//  Created by Андрей Закусов on 17.11.2019.
//  Copyright © 2019 Закусов Андрей. All rights reserved.
//

import Foundation
import RealmSwift

class DBRealmConfig {
    static let shared = DBRealmConfig()
    private init(){}
    
    func setConfiguration() -> () {
        let config = Realm.Configuration(
            schemaVersion: 6
        )
        
        Realm.Configuration.defaultConfiguration = config
    }
}

class DBRealm {
    
    static let shared = DBRealm()
    
    private init(){}
    
    func getFriendsList() -> Results<UserVK>? {
        let realm = try! Realm()
        
        let friendsVK = realm.objects(UserVK.self)
        
        return friendsVK
    }
    
    func getGroupsList() -> Results<GroupRealm>? {
        let realm = try! Realm()
        
        let groups = realm.objects(GroupRealm.self)
        
        return groups
    }
    
    func getUser(id: Int) -> UserVK? {
        let realm = try! Realm()
       
        return realm.objects(UserVK.self).filter("id == %@", id).first
    }
    
    func getUserPhotos(user: UserVK) -> Results<PhotoVK>?{
       let realm = try! Realm()
        
       return realm.objects(PhotoVK.self).filter("User == %@", user)
    }
    
    func writeObjects<T: Object> (objects: [T], setProperties: [String : Any]? = nil) {
        let realm = try! Realm()
        try! realm.write {
            for object in objects {
                if setProperties != nil {
                    for property in setProperties! {
                        object[property.key] = property.value
                    }
                }
                
                realm.add(object, update: .modified)
            }
        }
    }
    
}
