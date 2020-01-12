//
//  OnePhotoSwipeView.swift
//  MyVk
//
//  Created by kio on 12.10.2019.
//  Copyright © 2019 kio. All rights reserved.
//

import UIKit

class OnePhotoView: UIView {
    
    var friend: UserVK?{
        didSet {
            setupView()
        }
    }
    
    private var photoView1 = OnePhotoFrameView()
    private var photoView2 = OnePhotoFrameView()
    private var photoView3 = OnePhotoFrameView()
    
    var indexСurrentView = 1
    private var numCurrentView0 = 0
    private var numCurrentView1 = 1
    private var numCurrentView2 = 2
    
    private var viewCollection = [OnePhotoFrameView]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(moveToNextItem(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(moveToNextItem(_:)))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        addGestureRecognizer(leftSwipe)
        addGestureRecognizer(rightSwipe)
    }
    
    @objc func moveToNextItem(_ sender:UISwipeGestureRecognizer) {
        
        switch sender.direction {
        case .left:
            onLeftSwipe()
        case .right:
            onRightSwipe()
        default: break
        }
        
    }
    
    func setupView() {
        
        if friend == nil { return }
        
        viewCollection = []
        
      //  photoView1.photo = friend?.photos[indexСurrentView - 1]
        
     //   photoView2.photo = friend?.photos[indexСurrentView]
        
    //    photoView3.photo = friend?.photos[indexСurrentView + 1]
        
        viewCollection.append(photoView1)
        viewCollection.append(photoView2)
        viewCollection.append(photoView3)
        
        
        addSubview(photoView1)
        addSubview(photoView2)
        addSubview(photoView3)
        
        photoView2.frame = self.bounds
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
    
    @objc func onRightSwipe() {
        
        if indexСurrentView - 1 < 0 { return }
         
        let cView0 = viewCollection[numCurrentView0]
        let cView1 = viewCollection[numCurrentView1]
        let cView2 = viewCollection[numCurrentView2]
        
      //  cView0.photo = friend?.photos[indexСurrentView - 1]
        
      //  cView1.photo = friend?.photos[indexСurrentView]
        
        //cView2.photo = friend?.photos[indexСurrentView + 1]
        
        
        var originBounds0 = self.bounds
        originBounds0.origin.x += 500
        
        let originBounds2 = self.bounds
        
        
        
        cView0.layer.zPosition = 20
        cView1.layer.zPosition = 30
        cView2.layer.zPosition = 10
        
        cView0.transform = .identity
        cView1.transform = .identity
        cView2.transform = .identity
        
        cView0.frame = originBounds2
        
        
        let scale = CGAffineTransform(scaleX: 0.8, y: 0.8)
        cView0.transform = scale
        
        UIView.animateKeyframes(withDuration: 1,
                                delay: 0,
                                options: [],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.25,
                                                       animations: {
                                                        cView1.frame = originBounds0
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.1,
                                                       relativeDuration: 0.25,
                                                       animations: {
                                                        cView0.transform = .identity
                                    })
                                    
        },
                                completion: nil)
        
        switch numCurrentView0 {
        case 0: numCurrentView0 = 2; numCurrentView1 = 0; numCurrentView2 = 1
        case 1: numCurrentView0 = 0; numCurrentView1 = 1; numCurrentView2 = 2
        case 2: numCurrentView0 = 1; numCurrentView1 = 2; numCurrentView2 = 0
        default: numCurrentView0 = 0
        }
        
        indexСurrentView -= 1
    }
    
    @objc func onLeftSwipe() {
        
       // if indexСurrentView + 1 > (friend?.photos.count ?? 0) - 1 { return }
        
        let cView0 = viewCollection[numCurrentView0]
        let cView1 = viewCollection[numCurrentView1]
        let cView2 = viewCollection[numCurrentView2]
        
        
      //  cView1.photo = friend?.photos[indexСurrentView]
        
      //  cView2.photo = friend?.photos[indexСurrentView + 1]
        
        var originBounds0 = self.bounds
        originBounds0.origin.x += 500
        
        let originBounds2 = self.bounds
        
        cView0.layer.zPosition = 0
        cView1.layer.zPosition = 1
        cView2.layer.zPosition = 2
        
        cView0.transform = .identity
        cView1.transform = .identity
        cView2.transform = .identity
        
        cView1.frame = originBounds2
        cView2.frame = originBounds0
        cView0.frame = originBounds0
        
        let scale = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animateKeyframes(withDuration: 1,
                                delay: 0,
                                options: [],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.25,
                                                       animations: {
                                                        cView1.transform = scale
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.1,
                                                       relativeDuration: 0.25,
                                                       animations: {
                                                        cView2.frame = originBounds2
                                    })
                                    
        },
                                completion: nil)
        
        switch numCurrentView0 {
        case 0: numCurrentView0 = 1; numCurrentView1 = 2; numCurrentView2 = 0
        case 1: numCurrentView0 = 2; numCurrentView1 = 0; numCurrentView2 = 1
        case 2: numCurrentView0 = 0; numCurrentView1 = 1; numCurrentView2 = 2
        default: numCurrentView0 = 0
        }
        
        indexСurrentView += 1
    }
    
}




class OnePhotoFrameView: UIView {
    
    var photo: PhotoVK?{
        didSet {
            setupView()
        }
    }
    
    private var photoView = UIImageView()
    private var photoView1 = UIImageView()
    private var likeView = LikeView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        
    }
    
    func setupView() {
        
        photoView.image = photo?.foto
        photoView.contentMode = .scaleAspectFit
        
        likeView.photo = photo
        likeView.imageHaveLike = UIImage(systemName: "suit.heart.fill")
        likeView.imageNoLike = UIImage(systemName: "suit.heart")
        likeView.likeNumber = photo?.likeNumber ?? 0
        
        addSubview(photoView)
        
        addSubview(likeView)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = .white
        
        var originBounds1 = self.bounds
        originBounds1.size.height = originBounds1.size.height - 40
        photoView.frame = originBounds1
        
        likeView.frame = CGRect(x: originBounds1.width - 60, y: originBounds1.height + 5, width: 60, height: 30)
        //likeView.layer.zPosition = 10
    }
    
}
