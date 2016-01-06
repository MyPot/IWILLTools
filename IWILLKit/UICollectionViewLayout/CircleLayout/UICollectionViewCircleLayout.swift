//
//  UICollectionViewCircleLayout.swift
//  IWILLKit
//
//  Created by Lynch Wong on 1/6/16.
//  Copyright © 2016 Lynch Wong. All rights reserved.
//

import UIKit

public class UICollectionViewCircleLayout: UICollectionViewLayout {
    
    public var center: CGPoint!
    public var radius: CGFloat!
    public var cellCount: NSInteger!
    
    var deleteIndexPaths: [NSIndexPath] = []
    var insertIndexPaths: [NSIndexPath] = []
    
    public override func prepareLayout() {
        super.prepareLayout()
        
        if let size = collectionView?.frame.size {
            if let count = collectionView?.numberOfItemsInSection(0) {
                cellCount = count
            }
            center = CGPoint(x: size.width / 2, y: size.height / 2)
            radius = min(size.width, size.height) / 2.5
        }
    }
    
    public override func collectionViewContentSize() -> CGSize {
        if let size = collectionView?.frame.size {
            return size
        }
        return CGSizeZero
    }
    
    public override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        attributes.size = CGSizeMake(70, 70)
        attributes.center = CGPointMake(center.x + radius * CGFloat(cosf(Float(M_PI * 2 / Double(cellCount) * Double(indexPath.item)))),
                                        center.y + radius * CGFloat(sinf(Float(M_PI * 2 / Double(cellCount) * Double(indexPath.item))))
                            )
        return attributes
    }
    
    public override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        for var index = 0; index < cellCount; index++ {
            let indexPath = NSIndexPath(forItem: index, inSection: 0)
            if let attr = layoutAttributesForItemAtIndexPath(indexPath) {
                attributes.append(attr)
            }
        }
        return attributes
    }
    
    public override func prepareForCollectionViewUpdates(updateItems: [UICollectionViewUpdateItem]) {
        super.prepareForCollectionViewUpdates(updateItems)
        
        for update in updateItems {
            if update.updateAction == UICollectionUpdateAction.Delete {
                if let indexPath = update.indexPathBeforeUpdate {
                    deleteIndexPaths.append(indexPath)
                }
            } else if update.updateAction == UICollectionUpdateAction.Insert {
                if let indexPath = update.indexPathAfterUpdate {
                    insertIndexPaths.append(indexPath)
                }
            }
        }
    }
    
    public override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        deleteIndexPaths = []
        insertIndexPaths = []
    }
    
    public override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        var attributes = super.initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath)
        if insertIndexPaths.contains(itemIndexPath) {
            if attributes == nil {
                attributes = layoutAttributesForItemAtIndexPath(itemIndexPath)
            }
            attributes?.alpha = 0.0
            attributes?.center = CGPoint(x: center.x, y: center.y)
        }
        return attributes
    }
    
    public override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        var attributes = super.finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath)
        if deleteIndexPaths.contains(itemIndexPath) {
            if attributes == nil {
                attributes = layoutAttributesForItemAtIndexPath(itemIndexPath)
            }
            attributes?.alpha = 0.0
            attributes?.center = CGPoint(x: center.x, y: center.y)
            attributes?.transform3D = CATransform3DMakeScale(0.1, 0.1, 1)
        }
        return attributes
    }

}
