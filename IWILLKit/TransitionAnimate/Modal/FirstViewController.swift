//
//  FirstViewController.swift
//  IWILLKit
//
//  Created by Lynch Wong on 1/8/16.
//  Copyright © 2016 Lynch Wong. All rights reserved.
//

import UIKit

public class FirstViewController: UIViewController {
    
    private var percentDrivenTransition: UIPercentDrivenInteractiveTransition!

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        transitioningDelegate = self
        
        let imageView = UIImageView(frame: view.bounds)
        imageView.image = UIImage(named: "taylor")!
        view.addSubview(imageView)
        
        let button = UIButton(frame: CGRect(x: (view.bounds.size.width - 150) / 2, y: (view.bounds.size.height - 30) / 2, width: 150, height: 30))
        button.backgroundColor = UIColor.redColor()
        button.layer.cornerRadius = 15
        button.setTitle("跳转", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.addTarget(self, action: "action", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button)
        
        addScreenEdgePanGestureRecognizer(view, edges: UIRectEdge.Right)
    }
    
    func action() {
        let secondVC = SecondViewController()
        secondVC.transitioningDelegate = self
        addScreenEdgePanGestureRecognizer(secondVC.view, edges: UIRectEdge.Left)
        presentViewController(secondVC, animated: true, completion: nil)
    }
    
    func addScreenEdgePanGestureRecognizer(view: UIView, edges: UIRectEdge) {
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: Selector("edgePanGesture:"))
        edgePan.edges = edges
        view.addGestureRecognizer(edgePan)
    }
    
    func edgePanGesture(edgePan: UIScreenEdgePanGestureRecognizer) {
        let progress = abs(edgePan.translationInView(UIApplication.sharedApplication().keyWindow!).x) / UIApplication.sharedApplication().keyWindow!.bounds.width
        
        if edgePan.state == UIGestureRecognizerState.Began {
            percentDrivenTransition = UIPercentDrivenInteractiveTransition()
            if edgePan.edges == UIRectEdge.Right {
                action()
            } else if edgePan.edges == UIRectEdge.Left {
                dismissViewControllerAnimated(true, completion: nil)
            }
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

extension FirstViewController: UIViewControllerTransitioningDelegate {
    
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ModalShowTransitionAnimate()
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ModalDismissTransitionAnimate()
    }
    
    public func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return percentDrivenTransition
    }
    
    public func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return percentDrivenTransition
    }
    
}
