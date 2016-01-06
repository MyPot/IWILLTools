//
//  IWCache.swift
//  IWILLKit
//
//  Created by Lynch Wong on 12/30/15.
//  Copyright © 2015 Lynch Wong. All rights reserved.
//

import Foundation

/// 缓存目录的文件夹名字
private let cacheFolderName = "IWCache"

public class IWCache {
    
    /// 缓存完成后的回调
    public typealias Finish = (String?, NSError?) -> ()
    
    public static let sharedInstance = IWCache()
    
    /// 缓存目录
    public let iwCachePath: String
    
    /**
     为实现单例，设为private，防止外部再初始化实例。
     
     - returns: IWCache
     */
    private init() {
        //拼接缓存目录
        iwCachePath = (FileUtils.cachesDirectory as NSString).stringByAppendingPathComponent(cacheFolderName)
        //创建缓存目录
        createIWCacheFolder()
    }
    
    /**
     创建缓存目录
     */
    private func createIWCacheFolder() {
        var isDir = ObjCBool(false)
        let isExists = FileUtils.fileExistsAtPath(iwCachePath, isDirectory: &isDir)
        if !(isExists && isDir) {//不存在就创建
            do {
                try FileUtils.createDirectoryAt(iwCachePath)
            } catch {
                print("创建缓存目录失败")
            }
        }
    }
    
    /**
     判断 URL 是否已经缓存过了。
     
     - parameter filePaht: 根据URL生成对应的文件的路径
     
     - returns: true: 缓存过，false：没有。
     */
    public func cacheExistsWithdestinationPath(url: NSURL) -> (filePath: String, isExists: Bool) {
        //对URL进行MD5作为文件名
        let fileName = url.absoluteString.md5
        //文件路径
        let destinationPath = (iwCachePath as NSString).stringByAppendingPathComponent(fileName)
        let isExists = FileUtils.fileExistsAtPath(destinationPath)
        return (destinationPath, isExists)
    }

    public func dataWithURL(url: NSURL, finish: Finish) {
        
        let result = cacheExistsWithdestinationPath(url)
        
        //判断是否缓存过
        if result.isExists {
            finish(result.filePath, nil)//缓存过直接返回文件路径并退出
            return
        }
        
        //未缓存，对文件进行下载
        IWAPIManager.sharedInstance.downloadWithURL(url, saveToPath: result.filePath) {
            if let error = $1 {
                print("缓存失败!")
                finish(nil, error)
                return
            }
            
            guard let filePath = $0 else {
                print("缓存失败!")
                return
            }
            
            finish(filePath, nil)
        }
    }
    
}