//
//  VKAPI.swift
//  MyVk
//
//  Created by Андрей Закусов on 02.11.2019.
//  Copyright © 2019 Закусов Андрей. All rights reserved.
//

import Foundation
import RealmSwift

class VKAPI {
    
    func getFriendsList(completion: @escaping ([UserVK]) -> Void) -> () {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/friends.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "fields", value: "nickname,domain,sex,bdate,city,photo_50"),
            URLQueryItem(name: "v", value: "5.68"),
            URLQueryItem(name: "count", value: "10")
        ]
        
        let configuration = URLSessionConfiguration.default
        
        let session =  URLSession(configuration: configuration)
        
        let task = session.dataTask(with: urlComponents.url!) { (data, response, error) in
            
            guard let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) else {
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
            
            DBRealm.shared.writeObjects(objects: users)
            
            completion(users)
            
        }
        
        task.resume()
    }
    
    func getPhotosFriend(friendID: Int, completion: @escaping ([PhotoVK_]) -> Void) -> () {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/photos.getAll"
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "owner_id", value: String(friendID)),
            URLQueryItem(name: "v", value: "5.68"),
            URLQueryItem(name: "count", value: "10")
        ]
        
        // Конфигурация по умолчанию
        let configuration = URLSessionConfiguration.default
        
        // собственная сессия
        let session =  URLSession(configuration: configuration)
        
        let task = session.dataTask(with: urlComponents.url!) { (data, response, error) in
            guard let dataJson = data else { return }
            
            let json = try? JSONSerialization.jsonObject(with: dataJson, options: JSONSerialization.ReadingOptions.allowFragments)
            let jsonMain = json as! [String: Any]
            let response = jsonMain["response"] as! [String: Any]
            let array = response["items"] as! [[String: Any]]
            let photos = array.map { PhotoVK_(json: $0) }
            
//            var photoNumber = 1
//            for photo in photos {
//                let fileName = "\(friendID)\(photoNumber)_photo_130"
//                let folder = "photos"
//
//                FileStorage.shared.saveFile(webUrl: photo.Path130, fileName: fileName, folder: folder)
//
//                photo.Path130Local = folder + "/" + fileName
//
//                photoNumber += 1
//            }
            
//            DispatchQueue.main.async {
//
//                let owner = DBRealm.shared.getUser(id: friendID)
//                DBRealm.shared.writeObjects(objects: photos, setProperties: ["User" : owner as Any])
//
//            }
            
            completion(photos)
        }
        
        task.resume()
    }
    
    func getGroupsList(completion: @escaping ([GroupRealm]) -> Void) -> () {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/groups.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "v", value: "5.68"),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "count", value: "20")
        ]
        
        let configuration = URLSessionConfiguration.default
        
        let session =  URLSession(configuration: configuration)
        
        let task = session.dataTask(with: urlComponents.url!) { (data, response, error) in
            
            guard let dataJson = data else { return }
            
            let json = try? JSONSerialization.jsonObject(with: dataJson, options: JSONSerialization.ReadingOptions.allowFragments)
            
            let jsonMain = json as! [String: Any]
            let response = jsonMain["response"] as! [String: Any]
            let array = response["items"] as! [[String: Any]]
            let groups = array.map { GroupRealm(json: $0) }
            
            for group in groups {
                let fileName = "g\(group.id)_photo_50"
                FileStorage.shared.saveFile(webUrl: group.photo_50_str, fileName: fileName)
                group.photo_50_str_local = fileName
            }
            
            DBRealm.shared.writeObjects(objects: groups)
            
            completion(groups)
        }
        
        task.resume()
    }
    
    func getNewsList(completion: @escaping ([NewsVK], String) -> Void, start_from: String) -> () {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/newsfeed.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "v", value: "5.68"),
            URLQueryItem(name: "filters", value: "post"),
            URLQueryItem(name: "start_from", value: String(start_from)),
            URLQueryItem(name: "count", value: "10"),
            URLQueryItem(name: "fields", value: "name,photo_50")
            
            
        ]
        
        let configuration = URLSessionConfiguration.default
        
        let session =  URLSession(configuration: configuration)
        
        let task = session.dataTask(with: urlComponents.url!) { (data, response, error) in
            
            guard let dataJson = data else { return }
            
            let json = try? JSONSerialization.jsonObject(with: dataJson, options: JSONSerialization.ReadingOptions.allowFragments)
            
            let jsonMain = json as! [String: Any]
            let response = jsonMain["response"] as! [String: Any]
            let array = response["items"] as! [[String: Any]]
            let profiles = response["profiles"] as! [[String: Any]]
            let groups = response["groups"] as! [[String: Any]]
            let next_from = response["next_from"] as! String
            
            let news = array.map { NewsVK(json: $0, profiles: profiles, groups: groups) }
            
            completion(news, next_from)
        }
        
        task.resume()
    }
    
    func getSearchGroupsList(searchString: String, completion: @escaping ([GroupRealm]) -> Void) -> () {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/groups.search"
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "q", value: searchString),
            URLQueryItem(name: "v", value: "5.68"),
            URLQueryItem(name: "count", value: "10")
        ]
        
        let configuration = URLSessionConfiguration.default
        
        let session =  URLSession(configuration: configuration)
        
        let task = session.dataTask(with: urlComponents.url!) { (data, response, error) in
            guard let dataJson = data else { return }
            
            let json = try? JSONSerialization.jsonObject(with: dataJson, options: JSONSerialization.ReadingOptions.allowFragments)
            let jsonMain = json as! [String: Any]
            let response = jsonMain["response"] as! [String: Any]
            let array = response["items"] as! [[String: Any]]
            let groups = array.map { GroupRealm(json: $0) }
            completion(groups)
        }
        
        task.resume()
    }
    
}
