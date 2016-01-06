//
//  ZoomHeadTestViewController.swift
//  Demo
//
//  Created by Lynch Wong on 1/6/16.
//  Copyright © 2016 Lynch Wong. All rights reserved.
//

import UIKit
import IWILLKit

class ZoomHeadTestViewController: UIViewController {
    
    var dataSource = [UIImage]()
    
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let rect = CGRect(x: 0, y: 20, width: view.bounds.width, height: view.bounds.height - 20)
        let zoomHeadLayout = UICollectionViewZoomHeadLayout()
        collectionView = UICollectionView(frame: rect, collectionViewLayout: zoomHeadLayout)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(CollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "Identifier")
        view.addSubview(collectionView)
        
        let image = UIImage(named: "test.jpg")!
        for _ in 0...30 {
            dataSource.append(image)
        }
        
    }

}

extension ZoomHeadTestViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Identifier", forIndexPath: indexPath) as! CollectionViewCell
        cell.imageView.image = dataSource[indexPath.row]
        return cell
    }
    
}
