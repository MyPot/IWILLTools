//
//  Extensions.swift
//  IWILLKit
//
//  Created by Lynch Wong on 12/28/15.
//  Copyright © 2015 Lynch Wong. All rights reserved.
//

import UIKit

// MARK: - extension UIView

public extension UIView {
    
    /**
    在视图右上角显示圆点，默认为红色，圆点为UIView
    
    - parameter diameter: 圆点直径
    - parameter color:    圆点颜色
    */
    func showDot(diameter: CGFloat, color: UIColor = UIColor.redColor()) {
        let dotView = UIView(frame: CGRect(x: bounds.size.width - diameter, y: 0, width: diameter, height: diameter))
        dotView.backgroundColor = color
        dotView.tag = 9999;
        dotView.makeCornerRadius(diameter / 2)
        addSubview(dotView)
    }
    
    /**
     在视图右上角显示提醒视图，提醒视图为UIImageView，大小为图片的大小；!!!使用imageFromColor:生成的图片，然后设置圆角没有效果
     
     - parameter image: 提醒显示的图片
     */
    func showDot(image: UIImage) {
        let diameter = image.size.width
        let dotView = UIImageView(frame: CGRect(x: bounds.size.width - diameter * 2, y: diameter, width: diameter, height: diameter))
        dotView.image = image
        dotView.tag = 9999;
        dotView.makeCornerRadius(diameter / 2)
        addSubview(dotView)
    }
    
    /**
    隐藏视图右上角显示的点
    */
    func hiddenDot() {
        guard let dotView = viewWithTag(9999) else {
            print("dotView 视图不存在")
            return
        }
        dotView.removeFromSuperview()
    }
    
    /**
     设置圆角
     
     - parameter radiu: 圆角半径
     */
    func makeCornerRadius(radiu: CGFloat) {
        layer.cornerRadius = radiu
        layer.masksToBounds = true
    }
    
}

// MARK: - extension UIImage

public extension UIImage {
    
    /**
     生成指定颜色的图片
     
     - parameter color: 生成图片的颜色
     
     - returns: 图片
     */
    class func imageFromColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}

// MARK: - extension UIImageView

public extension UIImageView {
    
    //添加图片缓存
    func loadRemoteImageWithURL(url: NSURL, placeholderImage: UIImage? = nil) {
        
        //如果有占位图片，先设置占位图片
        if let placeholderImage = placeholderImage {
            image = placeholderImage
        }
        
        //判断是否有缓存
        let result = IWCache.sharedInstance.cacheExistsWithdestinationPath(url)
        
        if result.isExists {
            //有缓存，使用filePath生成data，data不为空且使用data生成的图片也不为空，那么就强制解析，然后退出
            if let imageData = NSData(contentsOfFile: result.filePath) where UIImage(data: imageData) != nil {
                image = UIImage(data: imageData)!
            }
            return
        }
        
        //没有缓存
        IWCache.sharedInstance.dataWithURL(url) {
            
            //缓存过程中有错误
            if $1 != nil {
                print("缓存图片发生错误!")
                return
            }
            
            //没有发生错误
            if let filePath = $0 {
                //使用filePath生成data，data不为空且使用data生成的图片也不为空，那么就强制解析，然后退出
                if let imageData = NSData(contentsOfFile: filePath) where UIImage(data: imageData) != nil {
                    self.image = UIImage(data: imageData)!
                }
            }
            
        }
    }
    
}

// MARK: - extension String

public extension String {
    
    /// 返回md5字符串
    var md5: String {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.dealloc(digestLen)
        
        return String(format: hash as String)
    }
    
}

// MARK: - extension UITableView

public extension UITableView {
    
    func reloadDataAnimateWithWave() {
        setContentOffset(contentOffset, animated: false)
        classForCoder.cancelPreviousPerformRequestsWithTarget(self)
        UIView.transitionWithView(self, duration: 0.1, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.hidden = true
                self.reloadData()
            }) { finished in
                if finished {
                    self.hidden = false
                    self.visibleRowsBeginAnimation()
                }
        }
    }
    
    private func visibleRowsBeginAnimation() {
        if let rows = indexPathsForVisibleRows {
            for var index = 0; index < rows.count; index++ {
                let indexPath = rows[index]
                let cell = cellForRowAtIndexPath(indexPath)
                cell?.frame = rectForRowAtIndexPath(indexPath)
                cell?.hidden = true
                cell?.layer.removeAllAnimations()
                performSelector("animationStart:", withObject: indexPath, afterDelay: 0.08 * Double(index))
            }
        }
    }
    
    func animationStart(indexPath: NSIndexPath) {
        let cell = cellForRowAtIndexPath(indexPath)!
        let originPoint = cell.center
        let beginPoint = CGPoint(x: cell.frame.size.width, y: originPoint.y)
        let endBounce1Point = CGPoint(x: originPoint.x - 2 * 4, y: originPoint.y)
        let endBounce2Point = CGPoint(x: originPoint.x + 4, y: originPoint.y)
        cell.hidden = false
        
        let move = CAKeyframeAnimation(keyPath: "position")
        move.keyTimes = [NSNumber(float: 0.0), NSNumber(float: 0.8), NSNumber(float: 0.9), NSNumber(float: 1.0)]
        move.values = [NSValue(CGPoint: beginPoint), NSValue(CGPoint: endBounce1Point), NSValue(CGPoint: endBounce2Point), NSValue(CGPoint: originPoint)]
        move.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let opa = CABasicAnimation(keyPath: "opacity")
        opa.fromValue = NSNumber(float: 0.0)
        opa.toValue = NSNumber(float: 1.0)
        opa.autoreverses = false
        
        let group = CAAnimationGroup()
        group.animations = [move, opa]
        group.duration = 0.25
        group.removedOnCompletion = false
        group.fillMode = kCAFillModeForwards
        
        cell.layer.addAnimation(group, forKey: nil)
    }
    
}