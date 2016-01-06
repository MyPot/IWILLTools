//
//  CollectionViewController.swift
//  Demo
//
//  Created by Lynch Wong on 1/5/16.
//  Copyright © 2016 Lynch Wong. All rights reserved.
//

import UIKit
import IWILLKit

class CollectionViewController: UIViewController {
    
    var dataSource = [UIImage]()
    
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let rect = CGRect(x: 0, y: 20, width: view.bounds.width, height: view.bounds.height - 20)
        let circleLayout = UICollectionViewCircleLayout()
        collectionView = UICollectionView(frame: rect, collectionViewLayout: circleLayout)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(UICollectionViewCircleCell.classForCoder(), forCellWithReuseIdentifier: "Identifier")
        view.addSubview(collectionView)
        
        let image = UIImage(named: "test.jpg")!
        for _ in 0...15 {
            dataSource.append(image)
        }
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
        collectionView.addGestureRecognizer(tapRecognizer)
    }
    
    func handleTapGesture(sender: UITapGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Ended {
            let initialPinchPoint = sender.locationInView(collectionView)
            let tappedCellPath = collectionView.indexPathForItemAtPoint(initialPinchPoint)
            if tappedCellPath != nil {
                dataSource.removeLast()
                collectionView.performBatchUpdates({ [unowned self] () -> Void in
                    self.collectionView.deleteItemsAtIndexPaths([tappedCellPath!])
                    }, completion: nil)
            } else {
                dataSource.append(UIImage(named: "test.jpg")!)
                collectionView.performBatchUpdates({ [unowned self] () -> Void in
                    self.collectionView.insertItemsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)])
                    }, completion: nil)
            }
        }
    }

}

extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Identifier", forIndexPath: indexPath) as! UICollectionViewCircleCell
        return cell
    }
    
}