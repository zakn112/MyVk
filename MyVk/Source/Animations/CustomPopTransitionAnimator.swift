//
//  CustomPopTransitionAnimator.swift
//  MyVk
//
//  Created by kio on 13.10.2019.
//  Copyright © 2019 kio. All rights reserved.
//

import UIKit

class CustomPopTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration: TimeInterval = 1
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from), let destination = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        transitionContext.containerView.sendSubviewToBack(destination.view)
        
        source.view.frame = transitionContext.containerView.frame
        destination.view.frame = transitionContext.containerView.frame
        
        let d_source_o = source.view.frame
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModePaced, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                destination.view.transform = .identity
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                let translation = CGAffineTransform(translationX: (d_source_o.height / 2 - d_source_o.width / 2), y: -(d_source_o.height / 2 + d_source_o.width / 2) )
                let rotation = CGAffineTransform(rotationAngle: -.pi / 2)
                source.view.transform = rotation.concatenating(translation)
            }
            
        }) { finished in
            if finished && !transitionContext.transitionWasCancelled {
                destination.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
}

