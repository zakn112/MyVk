//
//  News.swift
//  MyVk
//
//  Created by kio on 05/10/2019.
//  Copyright © 2019 kio. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class NewsVK{
    var name:String = ""
    var foto:UIImage?
    var content: String = ""
    var likesNumber: Int = 0
    var commentsNumber: Int = 0
    var text:String?
    var date:Date?
    var post_type:String = ""
    var photo_604:String?
    var autorName:String?
    var autorAvatar:String?
    var widthPhoto:Int?
    var heightPhoto:Int?
    var aspectRatio: CGFloat? {
        guard let height = heightPhoto, let width = widthPhoto else {
            return nil
        }
        return CGFloat(height)/CGFloat(width)
    }
    
    var isShowMore = false
    var newsLabelHightIsSowMore: CGFloat?
    var cellHeightIsSowMore: CGFloat?
    
    
    
    init(json: [String: Any], profiles: [[String: Any]], groups: [[String: Any]]) {
        
        let newsType = json["type"] as! String
        var source_id = json["source_id"] as! Int
        if source_id < 0 { source_id = -source_id}
        
        for elementProfile in profiles {
            let profile = elementProfile as [String: Any]
            if profile["id"] as! Int == source_id {
                autorName = "\(profile["first_name"] as! String) \(profile["last_name"] as! String)"
                autorAvatar = profile["photo_50"] as! String
            }
        }
        
        for elementGroupe in groups {
            let group = elementGroupe as [String: Any]
            if group["id"] as! Int == source_id {
                autorName = group["name"] as! String
                autorAvatar = group["photo_50"] as! String
            }
        }
        
        
        if newsType == "post" {
            
            name = json["text"] as! String
            
            if let attachments = json["attachments"] {
                let attachs = attachments as! [[String: Any]]
                for attach in attachs {
                    let attachType = attach["type"] as! String
                    if attachType == "photo" {
                        let attachPhoto = attach["photo"] as! [String: Any]
                        photo_604 = attachPhoto["photo_604"] as? String
                        //                    let url = URL(string: attachPhoto["photo_604"] as! String)
                        //                    if let data = try? Data(contentsOf: url!)
                        //                    {
                        //                        self.foto = UIImage(data: data)
                        //                    }
                        widthPhoto = attachPhoto["width"] as? Int ?? 0
                        heightPhoto = attachPhoto["height"] as? Int ?? 0
                    }
                }
                
            }
            
            if let likes = json["likes"] {
                let like = likes as! [String: Any]
                self.likesNumber = like["count"] as! Int
            }
            
            if let comments = json["comments"] {
                let comment = comments as! [String: Any]
                self.commentsNumber = comment["count"] as! Int
            }
        }
        
        if newsType == "photo" {
          let photos = json["photos"] as! [String: Any]
            
        }
        
    }
    
}
