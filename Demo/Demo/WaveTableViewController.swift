//
//  TestTableViewController.swift
//  Demo
//
//  Created by Lynch Wong on 1/4/16.
//  Copyright © 2016 Lynch Wong. All rights reserved.
//

import UIKit

class WaveTableViewController: UIViewController {
    
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView = UITableView(frame: view.bounds, style: UITableViewStyle.Plain)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadDataAnimateWithWave()
    }

}

extension WaveTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "BERootCellIden"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
        }
        cell?.textLabel?.text = "100"
        return cell!
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let animate = CABasicAnimation(keyPath: "opacity")
        animate.fromValue = NSNumber(float: 0.0)
        animate.toValue = NSNumber(float: 1.0)
        animate.duration = 5
        animate.autoreverses = false
        animate.removedOnCompletion = false

        cell.layer.addAnimation(animate, forKey: nil)
    }
    
}
