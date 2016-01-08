//
//  FromViewController.swift
//  IWILLKit
//
//  Created by Lynch Wong on 1/8/16.
//  Copyright © 2016 Lynch Wong. All rights reserved.
//

import UIKit

public class FromViewController: UIViewController {
    
    public var selectedCell: UICollectionViewCell!
    
    var dataSource = [UIImage]()
    
    public var collectionView: UICollectionView!

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let rect = CGRect(x: 0, y: 20, width: view.bounds.width, height: view.bounds.height - 20)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: view.bounds.width / 2, height: view.bounds.width / 2)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "Identifier")
        view.addSubview(collectionView)
        
        let image = UIImage(named: "h.png")!
        for _ in 0...15 {
            dataSource.append(image)
        }
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
    }

}

extension FromViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Identifier", forIndexPath: indexPath)
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        let imageView = UIImageView(image: dataSource[indexPath.row])
        imageView.frame = cell.bounds
        cell.contentView.addSubview(imageView)
        return cell
    }
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedCell = collectionView.cellForItemAtIndexPath(indexPath)
        let toVC = ToViewController()
        toVC.image = UIImage(named: "h.png")!
        navigationController?.pushViewController(toVC, animated: true)
    }
    
}

extension FromViewController: UINavigationControllerDelegate {
    public func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == UINavigationControllerOperation.Push {
            return PushTransitionAnimate()
        } else {
            return nil
        }
    }
}
