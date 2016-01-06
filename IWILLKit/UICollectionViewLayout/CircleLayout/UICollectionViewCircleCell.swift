//
//  UICollectionViewCIrcleCell.swift
//  IWILLKit
//
//  Created by Lynch Wong on 1/6/16.
//  Copyright © 2016 Lynch Wong. All rights reserved.
//

import UIKit

public class UICollectionViewCircleCell: UICollectionViewCell {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 35
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.whiteColor().CGColor
        contentView.backgroundColor = UIColor.grayColor()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
