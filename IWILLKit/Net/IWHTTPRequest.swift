//
//  IWHTTPRequest.swift
//  IWILLKit
//
//  Created by Lynch Wong on 12/30/15.
//  Copyright © 2015 Lynch Wong. All rights reserved.
//

import Foundation

public enum HTTPError: ErrorType {
    case BadURLString(String)
}

public class IWHTTPRequest {
    
    /**
     请求方法
     
     - parameter method:    GET, POST, PUT, DELETE 等等
     - parameter urlString: 请求地址
     - parameter params:    请求参数
     - parameter complete:  请求完成时的回调
     
     - throws: 错误抛出
     */
    public class func request(
        method: Method,
        urlString: String,
        parameters: [String: AnyObject]? = nil,
        encoding: ParameterEncoding = .URL,
        timeout: NSTimeInterval = 60)
        -> NSURLRequest
    {
        let url = NSURL(string: urlString)!
        var request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = method.rawValue
        request.timeoutInterval = timeout
        
        request = encoding.encode(request, parameters: parameters)

        return request
    }
    
}