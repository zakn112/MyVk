//
//  progressView.swift
//  MyVk
//
//  Created by kio on 05/10/2019.
//  Copyright © 2019 kio. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    
    @IBInspectable var imagePoint: UIImage?
    
    var imageView1 = UIImageView()
    var imageView2 = UIImageView()
    var imageView3 = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        removeSubviews()
        
        self.backgroundColor = .clear
        
        imageView1.image = imagePoint
        //imageView1.tintColor = .blue
        imageView2.image = imagePoint
        //imageView2.tintColor = .green
        imageView3.image = imagePoint
        //imageView3.tintColor = .red
        
        
        addSubview(imageView1)
        addSubview(imageView2)
        addSubview(imageView3)
        
//        UIView.animate(withDuration: 1.5, options: [.repeat, .autoreverse], animations: {
//            self.imageView1.alpha = 0.05
//        }) { completed in
//            UIView.animate(withDuration: 1.5) {
//                self.imageView2.alpha = 0.05
//            }
//        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.imageView1.alpha = 0.05
        })
        
        UIView.animate(withDuration: 0.5, delay: 0.25, options: [.repeat, .autoreverse], animations: {
            self.imageView2.alpha = 0.05
        })

        UIView.animate(withDuration: 0.5, delay: 0.5, options: [.repeat, .autoreverse], animations: {
            self.imageView3.alpha = 0.05
        })

    }
    
    func removeSubviews() {
        imageView1.removeFromSuperview()
        imageView2.removeFromSuperview()
        imageView3.removeFromSuperview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
       imageView1.frame = CGRect(x: 0, y: 0, width: self.bounds.width / 3, height: self.bounds.height)
       imageView2.frame = CGRect(x: self.bounds.width / 3, y: 0, width: self.bounds.width / 3, height: self.bounds.height)
       imageView3.frame = CGRect(x: self.bounds.width * 2 / 3, y: 0, width: self.bounds.width / 3, height: self.bounds.height)
        
    }
}

