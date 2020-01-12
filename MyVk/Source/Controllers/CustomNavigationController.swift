//
//  CustomNavigationController.swift
//  MyVk
//
//  Created by kio on 13.10.2019.
//  Copyright © 2019 kio. All rights reserved.
//

import UIKit

class CustomInteractiveTransition: UIPercentDrivenInteractiveTransition {
    var hasStarted: Bool = false
    var shouldFinished: Bool = false
}

class CustomNavigationController: UINavigationController, UINavigationControllerDelegate {

    let pushAnimator = CustomPushTransitionAnimator()
    let popAnimator = CustomPopTransitionAnimator()
    
    let interactiveTransition = CustomInteractiveTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        let edgePanGR = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgePanGestureCatched(_:)))
        edgePanGR.edges = .left
        view.addGestureRecognizer(edgePanGR)
    }

    //MARK: - UINavigationControllerDelegate
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch operation {
        case .push:
            return pushAnimator
        case .pop:
            return popAnimator
        case .none:
            return nil
        @unknown default:
            fatalError()
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.hasStarted ? interactiveTransition : nil
    }
    
    @objc func edgePanGestureCatched(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            interactiveTransition.hasStarted = true
            self.popViewController(animated: true)
        case .changed:
            guard let width = recognizer.view?.bounds.width else {
                interactiveTransition.hasStarted = false
                interactiveTransition.cancel()
                return
            }
            
            let translation = recognizer.translation(in: recognizer.view)
            let relativeTranlation = translation.x / width
            let progress = max(0, min(1, relativeTranlation))
            
            interactiveTransition.shouldFinished = progress > 0.4
            interactiveTransition.update(progress)
            
        case .ended:
            interactiveTransition.hasStarted = false
            interactiveTransition.shouldFinished ?
                interactiveTransition.finish() :
                interactiveTransition.cancel()
            
        case .cancelled:
            interactiveTransition.hasStarted = false
            interactiveTransition.cancel()
        default:
            break
        }
    }
    
}
