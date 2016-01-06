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
        
        imageView.frame = bounds
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        contentView.addSubview(imageView)
        
        label.frame = CGRect(x: 0, y: (bounds.size.height - 30) / 2, width: bounds.size.width, height: 30)
        label.text = "大头 UICollectionViewZoomHeadLayout"
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        contentView.addSubview(label)
        
        mask.frame = bounds
        mask.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        contentView.addSubview(mask)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
