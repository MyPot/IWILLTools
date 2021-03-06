//
//  ViewController.swift
//  Demo
//
//  Created by Lynch Wong on 12/13/15.
//  Copyright © 2015 Lynch Wong. All rights reserved.
//

import UIKit
import IWILLKit

class ViewController: UIViewController {

    var testView: UIView!
    
    let player = AudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        /// 复制指定目录的文件到目标目录，目录必须要存在才能复制成功
//        let location = NSBundle.mainBundle().URLForResource("log", withExtension: "log")!
//        let destination = FileUtils.sharedInstance.cachesDirectoryURL.URLByAppendingPathComponent("IWCachelog.log")
//        print(location)
//        print(destination)
//        do {
//            try FileUtils.sharedInstance.copyItemAtURL(location, destination: destination)
//        } catch let err as NSError {
//            print(err.localizedDescription)
//        }

//        /// 删除指定路径的文件，文件存在时才会执行删除操作，不存在没有操作
//        let path = FileUtils.sharedInstance.cachesDirectory + "/log.log"
//        try! FileUtils.sharedInstance.removeItemAtPath(path)
        
        // MARK: - TODO：测试上传
        
//        /**
//        *  上传，测试不成功，
//        */
//        let time = NSDate().timeIntervalSince1970
//        let request = IWHTTPRequest.request(Method.POST,
//            urlString: "",
//            parameters: [
//                "time": NSNumber(double: time),
//                "sid": NSNumber(integer: 135887)
//            ],
//            encoding: ParameterEncoding.URLEncodedInURL,
//            timeout: 60)
//        let fileURL = NSBundle.mainBundle().URLForResource("log", withExtension: "log")
//        
//        IWAPIManager.sharedInstance.uploadTaskWithRequest(request, fromFile: fileURL!) {
//            print($0)
//            print($1)
//        }
        
//        /**
//        *  下载
//        */
//        IWAPIManager.sharedInstance.downloadWithURL(NSURL(string: "")!) {
//        
//            if let error = $1 {
//                print(error.code)
//                print(error.localizedDescription)
//                return
//            }
//            
//            guard let filePath = $0 else {
//                print("下载失败!")
//                return
//            }
//            
//            let data = NSData(contentsOfFile: filePath)
//            let image = UIImage(data: data!)
//            let imageView = UIImageView(image: image)
//            imageView.frame = CGRect(x: 0, y: 20, width: 320, height: 133)
//            self.view.addSubview(imageView)
//        }
        
//        let path = FileUtils.sharedInstance.cachesDirectoryURL.URLByAppendingPathComponent("imagejpg").path!
//        IWAPIManager.sharedInstance.downloadWithURL(NSURL(string: "")!, saveToPath: path) {
//            
//            if let error = $1 {
//                print(error.code)
//                print(error.localizedDescription)
//                return
//            }
//            
//            guard let filePath = $0 else {
//                print("下载失败!")
//                return
//            }
//            
//            let data = NSData(contentsOfFile: filePath)
//            let image = UIImage(data: data!)
//            let imageView = UIImageView(image: image)
//            imageView.frame = CGRect(x: 0, y: 20, width: 320, height: 200)
//            self.view.addSubview(imageView)
//        }
        
//        let request = NSMutableURLRequest(URL: NSURL(string: "")!)
//        IWAPIManager.sharedInstance.downloadWithRequest(request) {
//            if let error = $1 {
//                print(error.code)
//                print(error.localizedDescription)
//                return
//            }
//            
//            guard let filePath = $0 else {
//                print("下载失败!")
//                return
//            }
//            
//            let image = UIImage(data: NSData(contentsOfFile: filePath)!)!
//            let imageView = UIImageView(image: image)
//            imageView.frame = CGRect(x: 0, y: 0, width: 400, height: 133)
//            self.view.addSubview(imageView)
//        }
        
//        let path = FileUtils.sharedInstance.cachesDirectoryURL.URLByAppendingPathComponent("requestimagejpg").path!
//        let requestS = NSMutableURLRequest(URL: NSURL(string: "")!)
//        IWAPIManager.sharedInstance.downloadWithRequest(requestS, saveToPath: path) {
//            if let error = $1 {
//                print(error.code)
//                print(error.localizedDescription)
//                return
//            }
//            
//            guard let filePath = $0 else {
//                print("下载失败!")
//                return
//            }
//            
//            let image = UIImage(data: NSData(contentsOfFile: filePath)!)!
//            let imageView = UIImageView(image: image)
//            imageView.frame = CGRect(x: 0, y: 0, width: 400, height: 200)
//            self.view.addSubview(imageView)
//        }
        
//        /**
//        *   测试缓存
//        */
//        IWCache.sharedInstance.dataWithURL(NSURL(string: "")!) { (filePath, error) in
//            print(filePath)
//            print(error)
//            let data = NSData(contentsOfFile: filePath!)
//            let image = UIImage(data: data!)
//            let imageView = UIImageView(image: image)
//            imageView.frame = CGRect(x: 0, y: 20, width: 320, height: 133)
//            self.view.addSubview(imageView)
//        }

//        /**
//        *  请求
//        */
//        testView = UIView(frame: CGRect(x: 50.0, y: 50.0, width: 100.0, height: 100.0))
//        testView.backgroundColor = UIColor.blueColor()
//        view.addSubview(testView)
//        
//        let parameters = [
//            "password": "200820e3227815ed1756a6b531e7e0d2",
//            "source": "3",
//            "username": "18580897856"
//        ]
//        IWAPIManager.sharedInstance.login(parameters) {
//            
//            if let error = $1 {
//                print(error.code)
//                print(error.localizedDescription)
//                return
//            }
//            
//            guard let result = $0 as? NSDictionary,
//                data = result["data"] as? NSDictionary,
//                errorCode = result["errorCode"] as? Int,
//                errorMsg = result["errorMsg"] as? String
//                else {
//                print("获取返回数据失败!")
//                return
//            }
//            
//            print(data)
//            print(errorMsg)
//            print(errorCode)
//            
//            // 更新界面
//        }

        
//        //播放本地音频
//        let url = NSBundle.mainBundle().URLForResource("music", withExtension: "mp3")!
//        player.playSoundEffect(url) { () -> () in
//            print("Play Done!")
//        }
        
//        /**
//        *   测试缓存 音频
//        */
//        IWCache.sharedInstance.dataWithURL(NSURL(string: "")!) { (filePath, error) in
//            print(filePath)
//            print(error)
//            self.player.playSoundEffect(NSURL(fileURLWithPath: filePath!), complete: { () -> () in
//                print("Play Done!")
//            })
//        }
        
//        //测试音频
//        let url = NSURL(string: "")!
////        let url = NSBundle.mainBundle().URLForResource("music", withExtension: "mp3")!
//        
////        player.playRemoteSoundWithURL(url) {
////            print($0)
        
////        }
//        
//        player.playRemoteSoundUseCacheWithURL(url) {
//            print($0)
//        }
        
//        //测试图片缓存
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 20, width: view.bounds.size.width, height: 200))
//        imageView.loadRemoteImageWithURL(NSURL(string: "")!, placeholderImage: UIImage(named: "test.jpg"))
//        view.addSubview(imageView)
        
//        DeviceUtils.sharedInstance.appStoreVersionWithAppID("") { didHasUpdate in
//            if didHasUpdate {
//                print("Has Update!")
//            }
//        }
        
        let button = UIButton(frame: CGRect(x: 50, y: 100, width: 100, height: 30))
        button.backgroundColor = UIColor.orangeColor()
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.setTitle("Push", forState: UIControlState.Normal)
        button.addTarget(self, action: "push", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button)
    }
    
    func push() {
        navigationController?.pushViewController(WaveTableViewController(), animated: true)
    }

}

