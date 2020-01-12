//
//  PhotoCollectionViewCell.swift
//  MyVk
//
//  Created by kio on 30/09/2019.
//  Copyright © 2019 kio. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoMainView: UIView!
    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var likeView: LikeView!
    
    override func awakeFromNib() {
        photoMainView.layer.masksToBounds = true
        photoMainView.layer.borderColor = UIColor.gray.cgColor
        photoMainView.layer.borderWidth = 1
        photoMainView.layer.cornerRadius = 15
    }
   
}
