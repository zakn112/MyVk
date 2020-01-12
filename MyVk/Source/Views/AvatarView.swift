//
//  AvatarView.swift
//  MyVk
//
//  Created by kio on 01/10/2019.
//  Copyright © 2019 kio. All rights reserved.
//

import UIKit

class AvatarView: UIView {
    
    @IBInspectable var shadowColor: UIColor = .gray
    @IBInspectable var shadowRadius: CGFloat = 0
    @IBInspectable var shadowOpacity: Float = 1
    
    @IBInspectable var image: UIImage?{
        didSet {
            setupView()
        }
    }
    
    private let shadowView = UIView()
    private let imageView = UIImageView()
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(onTap))
        recognizer.numberOfTapsRequired = 1    // Количество нажатий, необходимое для распознавания
        recognizer.numberOfTouchesRequired = 1 // Количество пальцев, которые должны коснуться экрана для распознавания
        return recognizer
    }()
    
    @objc func onTap() {
        
        let originBounds = self.imageView.bounds
        let newBounds = CGRect(x: originBounds.origin.x, y: originBounds.origin.y, width: originBounds.width - 10, height: originBounds.height - 10)

        self.imageView.bounds = newBounds
        
        UIView.animate(withDuration: 0.5,
                   delay: 0,
                   usingSpringWithDamping: 0.2,
                   initialSpringVelocity: 0,
                   options: [],
                   animations: {
                    self.imageView.bounds = originBounds
        })
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setupView() {
        self.backgroundColor = .clear
        removeSubviews()
        setupShadowView()
        setupImageView()
    }
    
    func removeSubviews() {
        shadowView.removeFromSuperview()
        imageView.removeFromSuperview()
    }
    
    func setupShadowView() {
        shadowView.backgroundColor = .white
        shadowView.layer.shadowColor = shadowColor.cgColor
        shadowView.layer.shadowRadius = shadowRadius
        shadowView.layer.shadowOpacity = shadowOpacity
        shadowView.layer.masksToBounds = false
        addSubview(shadowView)
    }
    
    func setupImageView() {
        imageView.image = image
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 1
        addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        shadowView.frame = self.bounds
        shadowView.layer.cornerRadius = shadowView.bounds.width / 2
        
        imageView.frame = self.bounds
        imageView.layer.cornerRadius = imageView.bounds.width / 2
    }
        
}
