//
//  UICollectionViewZoomHeadLayout.swift
//  IWILLKit
//
//  Created by Lynch Wong on 1/6/16.
//  Copyright © 2016 Lynch Wong. All rights reserved.
//

import UIKit

private let screenWidth = UIScreen.mainScreen().bounds.width
private let screenHeight = UIScreen.mainScreen().bounds.height

public class UICollectionViewZoomHeadLayout: UICollectionViewLayout {
    
    public var normailHeight: CGFloat = 100.0
    public var zoomBigHeight: CGFloat = 240.0
    
    private var cellCount: NSInteger!

    public override func prepareLayout() {
        super.prepareLayout()
        
        if let count = collectionView?.numberOfItemsInSection(0) {
            cellCount = count
        }
    }
    
    public override func collectionViewContentSize() -> CGSize {
        let size = CGSize(width: screenWidth, height: CGFloat((cellCount - 1) * 100 + 240))
        return size
    }
    
    public override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        if indexPath.row == 0 {
            attr.size = CGSize(width: screenWidth, height: zoomBigHeight)
            attr.center = CGPoint(x: screenWidth / 2, y: zoomBigHeight / 2)
        } else {
            attr.size = CGSize(width: screenWidth, height: normailHeight)
            attr.center = CGPoint(x: screenWidth / 2, y: zoomBigHeight + normailHeight / 2 + 100 * CGFloat(indexPath.row - 1))
        }
        return attr
    }
    
    public override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        for var index = 0; index < cellCount; index++ {
            let indexPath = NSIndexPath(forItem: index, inSection: 0)
            if let attr = layoutAttributesForItemAtIndexPath(indexPath) {
                if CGRectIntersectsRect(rect, attr.frame) {
                    attributes.append(attr)
                }
            }
        }
        return attributes
    }

}
