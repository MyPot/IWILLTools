//
//  UICollectionViewZoomHeadLayout.swift
//  IWILLKit
//
//  Created by Lynch Wong on 1/6/16.
//  Copyright © 2016 Lynch Wong. All rights reserved.
//

import UIKit

public class UICollectionViewZoomHeadLayout: UICollectionViewFlowLayout {
    
    public override init() {
        super.init()
        itemSize = CGSize(width: UIScreen.mainScreen().bounds.size.width, height: 100)
        scrollDirection = UICollectionViewScrollDirection.Vertical
        minimumLineSpacing = 0
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let targetRect = CGRect(x: 0, y: proposedContentOffset.y, width: collectionView!.bounds.size.width, height: collectionView!.bounds.size.height)
        let attributes = super.layoutAttributesForElementsInRect(targetRect)

        if let attributes = attributes {
            let offsetY = proposedContentOffset.y
            var offsetAdjustment: CGFloat = 0
            for attribute in attributes {
                let itemCenterY = attribute.center.y
                if abs(itemCenterY - offsetY)  < 50 {
                    offsetAdjustment = itemCenterY + 50.0
                }
            }
            return CGPoint(x: proposedContentOffset.x, y: offsetAdjustment)
        }
        return proposedContentOffset
    }
    
    public override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElementsInRect(rect)
//        let visibleRect = CGRect(origin: collectionView!.contentOffset, size: collectionView!.bounds.size)
        
        if let attributes = attributes {
            for attr in attributes {
                if CGRectIntersectsRect(attr.frame, rect) {
                    attr.transform3D = CATransform3DMakeScale(1.5, 1.5, 1.0)
                    attr.zIndex = 1
                }
            }
        }
        return attributes
    }

}
