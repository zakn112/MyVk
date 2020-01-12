//
//  NewsTableViewCell.swift
//  MyVk
//
//  Created by kio on 05/10/2019.
//  Copyright © 2019 kio. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var photoNews: UIImageView!
    
    @IBOutlet weak var viewNunber: UILabel!
    
    @IBOutlet weak var nameNews: UILabel!
    
    @IBOutlet weak var likeView: LikeView!
    
    @IBOutlet weak var autorName: UILabel!
    
    @IBOutlet weak var autorAvatar: AvatarView!
    
    @IBOutlet weak var NewsView: UIView!
    
    override func prepareForReuse() {
        photoNews.image = nil
        viewNunber.text = ""
        nameNews.text = ""
        autorName.text = ""
        autorAvatar.image = nil
    }
    
    override func awakeFromNib() {
        NewsView.layer.masksToBounds = true
        NewsView.layer.borderColor = UIColor.gray.cgColor
        NewsView.layer.borderWidth = 1
        NewsView.layer.cornerRadius = 15
    }
    
    
}
