//
//  SecondViewController.swift
//  IWILLKit
//
//  Created by Lynch Wong on 1/8/16.
//  Copyright © 2016 Lynch Wong. All rights reserved.
//

import UIKit

public class SecondViewController: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let imageView = UIImageView(frame: view.bounds)
        imageView.image = UIImage(named: "pure")!
        view.addSubview(imageView)
        
        let button = UIButton(frame: CGRect(x: 20, y: view.bounds.height - 70, width: 50, height: 50))
        button.backgroundColor = UIColor.redColor()
        button.layer.cornerRadius = 25
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.setTitle("返回", forState: UIControlState.Normal)
        button.addTarget(self, action: "action", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button)
    }
    
    func action() {
        print("action")
        (transitioningDelegate as! UIViewController).dismissViewControllerAnimated(true, completion: nil)
    }

}
