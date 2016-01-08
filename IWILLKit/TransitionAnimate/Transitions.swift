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

public class ModalShowTransitionAnimate: NSObject, UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.8
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let frVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! UINavigationController
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! SecondViewController
        
        let container = transitionContext.containerView()!
        container.addSubview(toVC.view)
        container.bringSubviewToFront(frVC.view)
        
        var transfrom = CATransform3DIdentity
        transfrom.m34 = -0.002
        container.layer.sublayerTransform = transfrom
        
        let initalFrame = transitionContext.initialFrameForViewController(frVC)
        toVC.view.frame = initalFrame
        frVC.view.frame = initalFrame
        frVC.view.layer.anchorPoint = CGPointMake(0, 0.5)
        frVC.view.layer.position = CGPointMake(0, initalFrame.height / 2.0)
        
        //添加阴影效果
        let shadowLayer = CAGradientLayer()
        shadowLayer.colors = [UIColor(white: 0, alpha: 1).CGColor, UIColor(white: 0, alpha: 0.5).CGColor, UIColor(white: 1, alpha: 0.5)]
        shadowLayer.startPoint = CGPointMake(0, 0.5)
        shadowLayer.endPoint = CGPointMake(1, 0.5)
        shadowLayer.frame = initalFrame
        let shadow = UIView(frame: initalFrame)
        shadow.backgroundColor = UIColor.clearColor()
        shadow.layer.addSublayer(shadowLayer)
        frVC.view.addSubview(shadow)
        shadow.alpha = 0
        
        //动画
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            frVC.view.layer.transform = CATransform3DMakeRotation(CGFloat(-M_PI_2), 0, 1, 0)
            shadow.alpha = 1.0
            }) { (finished: Bool) -> Void in
                frVC.view.layer.anchorPoint = CGPointMake(0.5, 0.5)
                frVC.view.layer.position = CGPointMake(CGRectGetMidX(initalFrame), CGRectGetMidY(initalFrame))
                frVC.view.layer.transform = CATransform3DIdentity
                shadow.removeFromSuperview()
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
    
}

public class ModalDismissTransitionAnimate: NSObject, UIViewControllerAnimatedTransitioning {

    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.8
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let frVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! SecondViewController
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! UINavigationController
        let container = transitionContext.containerView()!
        container.addSubview(toVC.view)
        
        //改变m34
        var transfrom = CATransform3DIdentity
        transfrom.m34 = -0.002
        container.layer.sublayerTransform = transfrom
        
        //设置anrchPoint 和 position
        let initalFrame = transitionContext.initialFrameForViewController(frVC)
        toVC.view.frame = initalFrame
        toVC.view.layer.anchorPoint = CGPointMake(0, 0.5)
        toVC.view.layer.position = CGPointMake(0, initalFrame.height / 2.0)
        toVC.view.layer.transform = CATransform3DMakeRotation(CGFloat(-M_PI_2), 0, 1, 0)
        
        //添加阴影效果
        let shadowLayer = CAGradientLayer()
        shadowLayer.colors = [UIColor(white: 0, alpha: 1).CGColor, UIColor(white: 0, alpha: 0.5).CGColor, UIColor(white: 1, alpha: 0.5)]
        shadowLayer.startPoint = CGPointMake(0, 0.5)
        shadowLayer.endPoint = CGPointMake(1, 0.5)
        shadowLayer.frame = initalFrame
        let shadow = UIView(frame: initalFrame)
        shadow.backgroundColor = UIColor.clearColor()
        shadow.layer.addSublayer(shadowLayer)
        toVC.view.addSubview(shadow)
        shadow.alpha = 1
        
        //动画
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            toVC.view.layer.transform = CATransform3DIdentity
            shadow.alpha = 0
            }) { (finished: Bool) -> Void in
                toVC.view.layer.anchorPoint = CGPointMake(0.5, 0.5)
                toVC.view.layer.position = CGPointMake(CGRectGetMidX(initalFrame), CGRectGetMidY(initalFrame))
                shadow.removeFromSuperview()
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
        
    }
    
}