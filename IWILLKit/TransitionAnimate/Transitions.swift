//
//  Transitions.swift
//  IWILLKit
//
//  Created by Lynch Wong on 1/8/16.
//  Copyright © 2016 Lynch Wong. All rights reserved.
//

import UIKit

public class PushTransitionAnimate: NSObject, UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let frVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! FromViewController
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! ToViewController
        
        let container = transitionContext.containerView()!
        
        let snapshotView = frVC.selectedCell.snapshotViewAfterScreenUpdates(false)
        snapshotView.frame = container.convertRect(frVC.selectedCell.frame, fromView: frVC.collectionView)
        frVC.selectedCell.hidden = true
        
        toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
        toVC.view.alpha = 0
        
        container.addSubview(toVC.view)
        container.addSubview(snapshotView)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                snapshotView.frame = toVC.avatarImageView.frame
                toVC.view.alpha = 1
            }) { (finish) -> Void in
                frVC.selectedCell.hidden = false
                toVC.avatarImageView.image = toVC.image
                snapshotView.removeFromSuperview()
                //一定要记得动画完成后执行此方法，让系统管理 navigation
                transitionContext.completeTransition(true)
        }
    }
    
}

public class PopTransitionAnimate: NSObject, UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let frVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! ToViewController
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! FromViewController
        
        let container = transitionContext.containerView()!
        
        let snapshotView = frVC.avatarImageView.snapshotViewAfterScreenUpdates(false)
        snapshotView.frame = container.convertRect(frVC.avatarImageView.frame, fromView: frVC.view)
        frVC.avatarImageView.hidden = true
        
        toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
        toVC.selectedCell.hidden = true
        
        container.insertSubview(toVC.view, belowSubview: frVC.view)
        container.addSubview(snapshotView)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                snapshotView.frame = container.convertRect(toVC.selectedCell.frame, fromView: toVC.collectionView)
                frVC.view.alpha = 0
            }) { (finish) -> Void in
                toVC.selectedCell.hidden = false
                snapshotView.removeFromSuperview()
                frVC.avatarImageView.hidden = false
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
    
}