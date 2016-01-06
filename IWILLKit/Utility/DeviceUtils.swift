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