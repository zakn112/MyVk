//
//  LikeView.swift
//  MyVk
//
//  Created by kio on 02/10/2019.
//  Copyright © 2019 kio. All rights reserved.
//

import Foundation
import UIKit

class LikeView: UIView {
    
    var photo: PhotoVK?
    var likeNumber: Int = 0{
        didSet{
            setupView()
        }
    }
    
    @IBInspectable var imageNoLike: UIImage?
    @IBInspectable var imageHaveLike: UIImage?
    
    private let imageView = UIImageView()
    private let labelView = UILabel()
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(onTap))
        recognizer.numberOfTapsRequired = 1    // Количество нажатий, необходимое для распознавания
        recognizer.numberOfTouchesRequired = 1 // Количество пальцев, которые должны коснуться экрана для распознавания
        return recognizer
    }()
    
    @objc func onTap() {
        if likeNumber > 0 {
            likeNumber = 0
        }else{
            likeNumber = 1
        }
        
        if photo != nil {
            photo?.likeNumber = likeNumber
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, animations: {
            self.imageView.alpha = 0.05
        }){ completed in
            UIView.animate(withDuration: 0.2) {
            self.imageView.alpha = 1
        }
        }
    }
    
//    override init(frame: CGRect) {
//           super.init(frame: frame)
//           addGestureRecognizer(tapGestureRecognizer)
//       }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        addGestureRecognizer(tapGestureRecognizer)
    }
    
   func setupView() {
        removeSubviews()
    
    labelView.contentMode = .right
    
        if likeNumber > 0 {
            imageView.image = imageHaveLike
            imageView.tintColor = .red
            labelView.textColor = .red
        }else{
            imageView.image = imageNoLike
            imageView.tintColor = .blue
            labelView.textColor = .blue
        }
        //imageView.isUserInteractionEnabled = true
        
        labelView.text = String(likeNumber)
        
        addSubview(imageView)
        addSubview(labelView)
    }
    
    func removeSubviews() {
           imageView.removeFromSuperview()
           labelView.removeFromSuperview()
       }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageViewRect = CGRect(x: 0, y: 0, width: self.bounds.width / 3, height: self.bounds.height)
        imageView.frame = imageViewRect
        let labelViewRect = CGRect(x: self.bounds.width / 3, y: 0, width: self.bounds.width / 3 * 2, height: self.bounds.height)
        labelView.frame = labelViewRect
        
    }
    
    
    

}
