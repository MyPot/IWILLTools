//
//  IWAPIManager.swift
//  IWILLKit
//
//  Created by Lynch Wong on 12/31/15.
//  Copyright © 2015 Lynch Wong. All rights reserved.
//

import Foundation

//let baseURL = "http://source.360english.cn:2244/api-dev/V2/"
let baseURL = "http://192.168.2.245/api-dev/V2/"

/**
在主线程上执行任务

- parameter closure: 要执行的任务
*/
func runOnMainThread(closure: () -> ()) {
    if NSThread.isMainThread() {
        closure()
    } else {
        dispatch_async(dispatch_get_main_queue()) { closure() }
    }
}

/// 下载时没有指定存储路径，默认存储在该目录下: /Caches/IWDownload
private let downloadFolderName = "IWDownload"

public class IWAPIManager {

    /// 请求完成后的回调，参数为JSON解析后的对象和NSError
    public typealias DataCompletionHandler = (AnyObject?, NSError?) -> ()
    
    /// 下载完成后的回调，参数为下载完成保存之后的文件的路径、错误
    public typealias DownloadCompletionHandler = (String?, NSError?) -> ()
    
    /// 单例模式
    public static let sharedInstance = IWAPIManager()
    
    private let httpClient = IWHTTPClient.sharedInstance
    
    /// 下载时没有指定存储路径，默认存储在该目录下: /Caches/IWDownload
    public let iwDownloadPath: String
    
    /**
     为实现单例，设为private，防止外部再初始化实例。
     
     - returns: IWAPIManager
     */
    private init() {
        //拼接下载路径
        iwDownloadPath = (FileUtils.cachesDirectory as NSString).stringByAppendingPathComponent(downloadFolderName)
        //创建下载目录
        createIWDownloadFolder()
    }
    
    /**
     创建下载目录
     */
    private func createIWDownloadFolder() {
        var isDir = ObjCBool(false)//是否是目录
        let isExists = FileUtils.fileExistsAtPath(iwDownloadPath, isDirectory: &isDir)//是否存在
        if !(isExists && isDir) {//不存在就创建目录
            do {
                try FileUtils.createDirectoryAt(iwDownloadPath)//创建目录
            } catch {
                print("创建下载目录失败")
            }
        }
    }
    
    /**
     登录接口，回调运行在主线程上。
     
     - parameter parameters: 请求参数
     - parameter finish:     回调，运行在主线程上
     
     - returns: Task
     */
    public func login(parameters: [String: AnyObject], completionHandler: DataCompletionHandler? = nil) -> NSURLSessionDataTask {
        let action = "Students/login"
        let method = Method.POST
        return fire(method, action: action, parameters: parameters, completionHandler: completionHandler)
    }
    
    /**
     工厂方法，
     
     - parameter method:     请求方法
     - parameter action:     请求接口
     - parameter parameters: 请求参数
     - parameter finish:     回调，运行在主线程上
     
     - returns: Task
     */
    private func fire(method: Method, action: String, parameters: [String: AnyObject], completionHandler: DataCompletionHandler?) -> NSURLSessionDataTask {
        
        let urlString = baseURL + action
        
        return httpClient.request(Method.POST, urlString: urlString, parameters: parameters) {
            
            /// 没有回调时，直接返回
            guard let f = completionHandler else {
                return
            }
            
            /// 有错误时，传递错误给回调然后返回
            if let err = $2 {
                runOnMainThread { f(nil, err) }
                return
            }
    
            /// 对数据进行JSON解析，如有错误时传递错误给回调；否则传递结果给回调。这里可直接返回 resultData，根据需求进行修改。
            if let resultData = $0 {
                do {
                    let result = try NSJSONSerialization.JSONObjectWithData(resultData, options: NSJSONReadingOptions.MutableContainers)
                    runOnMainThread { f(result, nil) }
                } catch let err as NSError {
                    runOnMainThread { f(nil, err) }
                }
            }
        }
    }
    
    // MARK: - 下载
    
    /**
    根据指定的 NSURL 进行下载，回调运行在主线程上。saveToPath默认值为空，当没有指定该参数的值的时候文件存储在 /Caches/IWDownload 路径下。
    
    - parameter url:               指定的 NSURL
    - parameter saveToPath:        文件存储的路径
    - parameter completionHandler: 下载完成后的回调
    
    - returns: NSURLSessionDownloadTask
    */
    public func downloadWithURL(url: NSURL, saveToPath: String? = nil, completionHandler: DownloadCompletionHandler) -> NSURLSessionDownloadTask {
        return httpClient.downloadWithURL(url) {
            
            // 错误直接回调退出
            if let err = $2 {
                print("下载失败!")
                runOnMainThread { completionHandler(nil, err) }
                return
            }
            
            if let location = $0 {
                
                let destinationURL: NSURL//存储文件的URL
                
                if let destination = saveToPath {//赋值为用户指定的URL
                    destinationURL = NSURL(fileURLWithPath: destination)
                } else {//赋值为默认的URL
                    let fileName = url.absoluteString.md5
                    let destinationPath = (self.iwDownloadPath as NSString).stringByAppendingPathComponent(fileName)
                    destinationURL = NSURL(fileURLWithPath: destinationPath)
                }
                
                do{//复制文件到指定的URL
                    try FileUtils.copyItemAtURL(location, destination: destinationURL)
                } catch let err as NSError {
                    print("复制文件出错!")
                    runOnMainThread { completionHandler(nil, err) }
                }
                runOnMainThread { completionHandler(destinationURL.path, nil) }//返回存储过后的文件的路径
            }
            
        }
    }
    
    /**
     根据指定的 NSURLRequest 进行下载，回调运行在主线程上。saveToPath默认值为空，当没有指定该参数的值的时候文件存储在 /Caches/IWDownload 路径下。
     
     - parameter request:           指定的 NSURLRequest
     - parameter saveToPath:        文件存储的路径
     - parameter completionHandler: 下载完成后的回调
     
     - returns: NSURLSessionDownloadTask
     */
    public func downloadWithRequest(request: NSURLRequest, saveToPath: String? = nil, completionHandler: DownloadCompletionHandler) -> NSURLSessionDownloadTask {
        return httpClient.downloadWithRequest(request) {
 
            // 错误直接回调退出
            if let err = $2 {
                print("下载失败!")
                runOnMainThread { completionHandler(nil, err) }
                return
            }
            
            if let location = $0 {
                
                let destinationURL: NSURL//存储文件的URL
                
                if let destination = saveToPath {//赋值为用户指定的URL
                    destinationURL = NSURL(fileURLWithPath: destination)
                } else {//赋值为默认的URL
                    let fileName = request.URL!.absoluteString.md5
                    let destinationPath = (self.iwDownloadPath as NSString).stringByAppendingPathComponent(fileName)
                    destinationURL = NSURL(fileURLWithPath: destinationPath)
                }
                
                do{//复制文件到指定的URL
                    try FileUtils.copyItemAtURL(location, destination: destinationURL)
                } catch let err as NSError {
                    print("复制文件出错!")
                    runOnMainThread { completionHandler(nil, err) }
                }
                runOnMainThread { completionHandler(destinationURL.path, nil) }//返回存储过后的文件的路径
            }
            
        }
    }
    
    // MARK: - 上传
    // MARK: - TODO: 测试上传
    
    public func uploadTaskWithRequest(request: NSURLRequest, fromData: NSData, completionHandler: DataCompletionHandler? = nil) -> NSURLSessionUploadTask {
        return httpClient.uploadTaskWithRequest(request, fromData: fromData) {
            guard let f = completionHandler else {
                return
            }
            
            if let err = $2 {
                runOnMainThread { f(nil, err) }
                return
            }
            
            if let resultData = $0 {
                runOnMainThread { f(resultData, nil) }
            }
        }
    }
    
    public func uploadTaskWithRequest(request: NSURLRequest, fromFile: NSURL, completionHandler: DataCompletionHandler? = nil) -> NSURLSessionUploadTask {
        return httpClient.uploadTaskWithRequest(request, fromFile: fromFile) {
            guard let f = completionHandler else {
                return
            }
            
            if let err = $2 {
                runOnMainThread { f(nil, err) }
                return
            }
            
            if let resultData = $0 {
                runOnMainThread { f(resultData, nil) }
            }
        }
    }
    
}