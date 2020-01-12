//
//  CustomPushTransitionAnimator.swift
//  MyVk
//
//  Created by kio on 13.10.2019.
//  Copyright © 2019 kio. All rights reserved.
//

import UIKit

class CustomPushTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration: TimeInterval = 1
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from), let destination = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        source.view.frame = transitionContext.containerView.frame
        
        let d_frame_o = destination.view.frame
        let translation = CGAffineTransform(translationX: (d_frame_o.height / 2 - d_frame_o.width / 2), y: -(d_frame_o.height / 2 + d_frame_o.width / 2) )
        let rotation = CGAffineTransform(rotationAngle: -.pi / 2)
        destination.view.transform = rotation.concatenating(translation)
        
     
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModePaced, animations: {
          
          
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.375) {
                destination.view.transform = .identity
            }
        }) { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
}

