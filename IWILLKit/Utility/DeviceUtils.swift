//
//  DeviceUtils.swift
//  IWILLKit
//
//  Created by Lynch Wong on 12/28/15.
//  Copyright © 2015 Lynch Wong. All rights reserved.
//

import Foundation

/// 设备信息类
public class DeviceUtils {
    
    /// 单例
    public static let sharedInstance = DeviceUtils()
    
    /**
     Private 防止使用初始化器来创建单例外的实例
     
     - returns: 单例
     */
    private init() {}
    
    /**
     私有方法，获取NSBundle的infoDictionary
     
     - returns: Dictionary<String, AnyObject>?
     */
    private func getInfoDictionary() -> Dictionary<String, AnyObject>? {
        return NSBundle.mainBundle().infoDictionary
    }
    
    /**
     获取App版本名称，CFBundleShortVersionString
     
     - returns: String
     */
    public func appVersionName() -> String {
        guard let dic = getInfoDictionary() else {
            return ""
        }
        return dic["CFBundleShortVersionString"] as! String
    }
    
    /**
     从App Store获取当前App的版本号；获取到之后的回调，返回版本号与本地是否相同的布尔值。
     
     - parameter appId:    App ID
     - parameter complete: 获取到之后的回调，返回版本号与本地是否相同的布尔值。
     */
    public func appStoreVersionWithAppID(appId: String, complete: (Bool) -> ()) {
        
        IWHTTPClient.sharedInstance.request(Method.POST, urlString: "http://itunes.apple.com/lookup?id=\(appId)") {
            
            /// 有错误
            if $2 != nil {
                runOnMainThread { complete(false) }
                return
            }
            
            if let resultData = $0 {
                do {
                    let result = try NSJSONSerialization.JSONObjectWithData(resultData, options: NSJSONReadingOptions.MutableContainers)
                    if let dictionary = result as? NSDictionary {
                        if let array = dictionary["results"] as? NSArray {
                            if let dic = array.firstObject as? NSDictionary {
                                if let appStoreVersion = dic["version"] as? String {
                                    if appStoreVersion != self.appVersionName() {
                                        runOnMainThread { complete(true) }
                                    } else {
                                        runOnMainThread { complete(false) }
                                    }
                                } else {
                                    runOnMainThread { complete(false) }
                                }
                            } else {
                                runOnMainThread { complete(false) }
                            }
                        } else {
                            runOnMainThread { complete(false) }
                        }
                    } else {
                        runOnMainThread { complete(false) }
                    }
                } catch {
                    runOnMainThread { complete(false) }
                }
            }
            
        }
    }
    
    /**
     获取App版本号，CFBundleVersion
     
     - returns: String
     */
    public func appVersionCode() -> String {
        guard let dic = getInfoDictionary() else {
            return ""
        }
        return dic["CFBundleVersion"] as! String
    }
    
}