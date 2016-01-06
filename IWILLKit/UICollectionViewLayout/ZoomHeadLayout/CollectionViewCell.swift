//
//  CollectionViewCell.swift
//  IWILLKit
//
//  Created by Lynch Wong on 1/6/16.
//  Copyright © 2016 Lynch Wong. All rights reserved.
//

import UIKit

public class CollectionViewCell: UICollectionViewCell {
    
    public let imageView = UIImageView()
    public let label = UILabel()
    public let mask = UIView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    func initialize()  {
        
        clipsToBounds = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        contentView.addSubview(imageView)
        
        let imageLeft = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0)
        let imageTop = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0)
        let imageRight = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0)
        let imageBottom = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        contentView.addConstraints([imageLeft, imageTop, imageRight, imageBottom])
        
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "大头 UICollectionViewZoomHeadLayout"
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        contentView.addSubview(label)
        
        let labelLeft = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0)
        let labelRight = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0)
        let labelHeight = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 30)
        let labelCenterY = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
        label.addConstraint(labelHeight)
        contentView.addConstraints([labelLeft, labelRight, labelCenterY])
        
        
        mask.translatesAutoresizingMaskIntoConstraints = false
        mask.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        contentView.addSubview(mask)
        
        let maskLeft = NSLayoutConstraint(item: mask, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0)
        let maskTop = NSLayoutConstraint(item: mask, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0)
        let maskRight = NSLayoutConstraint(item: mask, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0)
        let maskBottom = NSLayoutConstraint(item: mask, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        contentView.addConstraints([maskLeft, maskTop, maskRight, maskBottom])
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
