//
//  VKAPIProtocolProxy.swift
//  MyVk
//
//  Created by Андрей Закусов on 21.03.2020.
//  Copyright © 2020 Закусов Андрей. All rights reserved.
//

import Foundation

protocol VKAPIInterface {
    func getFriendsList(completion: @escaping ([UserVK]) -> Void) -> ()
    func getPhotosFriend(friendID: Int, completion: @escaping ([PhotoVK_]) -> Void) -> ()
    func getGroupsList(completion: @escaping ([GroupsVK]) -> Void) -> ()
    func getNewsList(completion: @escaping ([NewsVK], String) -> Void, start_from: String) -> ()
    func getSearchGroupsList(searchString: String, completion: @escaping ([GroupsVK]) -> Void) -> ()
}

class VKAPIProtocolProxy: VKAPIInterface {
    let vkAPI: VKAPI
    init(vkAPI: VKAPI) {
        self.vkAPI = vkAPI
    }
    static var log = [(Date, String)]()
    
    func getFriendsList(completion: @escaping ([UserVK]) -> Void) {
        VKAPIProtocolProxy.log.append((Date(), "getFriendsList"))
        return vkAPI.getFriendsList(completion: completion)
    }
    
    func getPhotosFriend(friendID: Int, completion: @escaping ([PhotoVK_]) -> Void) {
        VKAPIProtocolProxy.log.append((Date(), "getPhotosFriend"))
        return vkAPI.getPhotosFriend(friendID: friendID, completion: completion)
    }
    
    func getGroupsList(completion: @escaping ([GroupsVK]) -> Void) {
        VKAPIProtocolProxy.log.append((Date(), "getGroupsList"))
        return vkAPI.getGroupsList(completion: completion)
    }
    
    func getNewsList(completion: @escaping ([NewsVK], String) -> Void, start_from: String) {
        VKAPIProtocolProxy.log.append((Date(), "getNewsList"))
        return vkAPI.getNewsList(completion: completion, start_from: start_from)
    }
    
    func getSearchGroupsList(searchString: String, completion: @escaping ([GroupsVK]) -> Void) {
        VKAPIProtocolProxy.log.append((Date(), "getSearchGroupsList"))
        return vkAPI.getSearchGroupsList(searchString: searchString, completion: completion)
    }
    
}
