//
//  OperationsVK.swift
//  MyVk
//
//  Created by Андрей Закусов on 06.01.2020.
//  Copyright © 2020 Закусов Андрей. All rights reserved.
//

import Foundation
import RealmSwift

class AsyncOperation: Operation {
    enum State: String {
        case ready, executing, finished
        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    override var isFinished: Bool {
        return state == .finished
    }
    override func start() {
        if isCancelled {
            state = .finished
        } else {
            main()
            state = .executing
        }
    }
    override func cancel() {
        super.cancel()
        state = .finished
    }
}

class GetDataPhotoOperation : AsyncOperation {
    
    override func cancel() {
        if task != nil {
        task!.cancel()
        }
        
        super.cancel()
        state = .finished
    }
    
    private var task: URLSessionDataTask?
    var friendID: Int = 0
    
    var photos = [PhotoVK]()
    
    override func main() {
        guard friendID != 0 else { return }
                
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
        
        self.task = session.dataTask(with: urlComponents.url!) { (data, response, error) in
            guard let dataJson = data else { return }
            
            let json = try? JSONSerialization.jsonObject(with: dataJson, options: JSONSerialization.ReadingOptions.allowFragments)
            let jsonMain = json as! [String: Any]
            let response = jsonMain["response"] as! [String: Any]
            let array = response["items"] as! [[String: Any]]
            self.photos = array.map { PhotoVK(json: $0) }
            
            var photoNumber = 1
            for photo in self.photos {
                let fileName = "\(self.friendID)\(photoNumber)_photo_604"
                let folder = "photos"
                
                FileStorage.shared.saveFile(webUrl: photo.Path604, fileName: fileName, folder: folder)
                
                photo.Path604Local = folder + "/" + fileName
                
                photoNumber += 1
            }
            
            self.state = .finished
        }
        
        if task != nil {
            self.task!.resume()
        }
    }
    
    init(friendID: Int) {
        self.friendID = friendID
    }
}


class SaveDataPhotoOperation: Operation {

    override func main() {
        guard let getDataPhotoOperation = dependencies.first as? GetDataPhotoOperation else { return }
        let photos = getDataPhotoOperation.photos
        let friendID = getDataPhotoOperation.friendID
        let owner = DBRealm.shared.getUser(id: friendID)
        DBRealm.shared.writeObjects(objects: photos, setProperties: ["User" : owner as Any])
        
    }
}
