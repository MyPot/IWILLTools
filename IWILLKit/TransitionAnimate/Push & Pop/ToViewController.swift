//
//  ToViewController.swift
//  IWILLKit
//
//  Created by Lynch Wong on 1/8/16.
//  Copyright © 2016 Lynch Wong. All rights reserved.
//

import UIKit

public class ToViewController: UIViewController {
    
    public var avatarImageView: UIImageView!
    public var image: UIImage!
    
    private var percentDrivenTransition: UIPercentDrivenInteractiveTransition!

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.whiteColor()
        
        let rect = CGRect(x: (view.bounds.width - 200) / 2, y: 80, width: 200, height: 200)
        avatarImageView = UIImageView(frame: rect)
        view.addSubview(avatarImageView)
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: "edgePanGesture:")
        edgePan.edges = UIRectEdge.Left
        view.addGestureRecognizer(edgePan)
    }
    
    func edgePanGesture(edgePan: UIScreenEdgePanGestureRecognizer) {
        let progress = edgePan.translationInView(view).x / view.bounds.width
        
        if edgePan.state == UIGestureRecognizerState.Began {
            percentDrivenTransition = UIPercentDrivenInteractiveTransition()
            navigationController?.popViewControllerAnimated(true)
        } else if edgePan.state == UIGestureRecognizerState.Changed {
            percentDrivenTransition?.updateInteractiveTransition(progress)
        } else if edgePan.state == UIGestureRecognizerState.Cancelled || edgePan.state == UIGestureRecognizerState.Ended {
            if progress > 0.5 {
                percentDrivenTransition?.finishInteractiveTransition()
            } else {
                percentDrivenTransition?.cancelInteractiveTransition()
            }
            percentDrivenTransition = nil
        }
    }

}

extension ToViewController: UINavigationControllerDelegate {
    
    public func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == UINavigationControllerOperation.Pop {
            return PopTransitionAnimate()
        } else {
            return nil
        }
    }
    
    public func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if animationController is PopTransitionAnimate {
            return percentDrivenTransition
        } else {
            return nil
        }
    }
    
}
