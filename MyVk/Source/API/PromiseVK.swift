//
//  PromiseVK.swift
//  MyVk
//
//  Created by Андрей Закусов on 18.01.2020.
//  Copyright © 2020 Закусов Андрей. All rights reserved.
//

import Foundation
import PromiseKit
import RealmSwift

class PromiseVK {
    static let shared = PromiseVK()
    private init(){}
    
    enum PromiseVKError: Error{
        case ParseJSON
        case SaveBase
    }
    
    
    func getFriendListJSON() -> Promise<(data: Data, response: URLResponse)> {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/friends.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "fields", value: "nickname,domain,sex,bdate,city,photo_50"),
            URLQueryItem(name: "v", value: "5.68"),
            URLQueryItem(name: "count", value: "30")
        ]
        
        let configuration = URLSessionConfiguration.default
        
        let session =  URLSession(configuration: configuration)
        
        return session.dataTask(.promise, with: urlComponents.url!)
    }
    
    func parseFriendList(data: Data, response: URLResponse) -> Promise<[UserVK]>{
        return Promise<[UserVK]>{ (resolver) in
            guard let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) else {
                resolver.reject(PromiseVKError.ParseJSON)
                return
            }
            
            let jsonMain = json as! [String: Any]
            let response = jsonMain["response"] as! [String: Any]
            let array = response["items"] as! [[String: Any]]
            let users = array.map { UserVK(json: $0) }
            
            for user in users {
                let fileName = "\(user.id)_photo_50"
                FileStorage.shared.saveFile(webUrl: user.photo_50_str, fileName: fileName)
                user.photo_50_str_local = fileName
            }
            
            resolver.fulfill(users)
            
        }
    }
    
    func saveFriendListDataBase(users: [UserVK]) -> Promise<Results<UserVK>>{
        return Promise<Results<UserVK>>{ (resolver) in
            DBRealm.shared.writeObjects(objects: users)
            
            if let usersRealm = DBRealm.shared.getFriendsList() {
                resolver.fulfill(usersRealm)}
            else{
                resolver.reject(PromiseVKError.SaveBase)
            }
             
        }
    }
    
    
}
