//
//  IWHTTPClient.swift
//  IWILLKit
//
//  Created by Lynch Wong on 12/31/15.
//  Copyright © 2015 Lynch Wong. All rights reserved.
//

import Foundation

public class IWHTTPClient {
    
    public typealias DataCompleteClosure = (NSData?, NSURLResponse?, NSError?) -> ()
    public typealias DownloadCompleteClosure = (NSURL?, NSURLResponse?, NSError?) -> ()
//    public typealias UploadCompleteClosure = 

    public static let sharedInstance: IWHTTPClient = {
        return IWHTTPClient()
    }()
    
    public let session: NSURLSession
    
    private init() {
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfiguration.HTTPAdditionalHeaders = IWHTTPClient.defaultHTTPHeaders
        session = NSURLSession(configuration: sessionConfiguration)
    }
    
    deinit {
        session.invalidateAndCancel()
    }
    
    public static let defaultHTTPHeaders: [String: String] = {
        // Accept-Encoding HTTP Header; see https://tools.ietf.org/html/rfc7230#section-4.2.3
        let acceptEncoding: String = "gzip;q=1.0,compress;q=0.5"
        
        // Accept-Language HTTP Header; see https://tools.ietf.org/html/rfc7231#section-5.3.5
        let acceptLanguage: String = {
            var components: [String] = []
            for (index, languageCode) in (NSLocale.preferredLanguages() as [String]).enumerate() {
                let q = 1.0 - (Double(index) * 0.1)
                components.append("\(languageCode);q=\(q)")
                if q <= 0.5 {
                    break
                }
            }
            
            return components.joinWithSeparator(",")
        }()
        
        // User-Agent Header; see https://tools.ietf.org/html/rfc7231#section-5.5.3
        let userAgent: String = {
            if let info = NSBundle.mainBundle().infoDictionary {
                let executable: AnyObject = info[kCFBundleExecutableKey as String] ?? "Unknown"
                let bundle: AnyObject = info[kCFBundleIdentifierKey as String] ?? "Unknown"
                let version: AnyObject = info[kCFBundleVersionKey as String] ?? "Unknown"
                let os: AnyObject = NSProcessInfo.processInfo().operatingSystemVersionString ?? "Unknown"
                
                var mutableUserAgent = NSMutableString(string: "\(executable)/\(bundle) (\(version); OS \(os))") as CFMutableString
                let transform = NSString(string: "Any-Latin; Latin-ASCII; [:^ASCII:] Remove") as CFString
                
                if CFStringTransform(mutableUserAgent, UnsafeMutablePointer<CFRange>(nil), transform, false) {
                    return mutableUserAgent as String
                }
            }
            
            return "IWILLKit"
        }()
        
        return [
            "Accept-Encoding": acceptEncoding,
            "Accept-Language": acceptLanguage,
            "User-Agent": userAgent
        ]
    }()
    
    // MARK: - 构建 NSURLRequest
    
    private func buildURLRquest(
        method: Method,
        urlString: String,
        parameters: [String: AnyObject]? = nil,
        encoding: ParameterEncoding = .URL,
        timeout: NSTimeInterval = 60) -> NSURLRequest
    {
        let URLRequest = IWHTTPRequest.request(method, urlString: urlString, parameters: parameters, encoding: encoding, timeout: timeout)
        return URLRequest
    }
    
    // MARK: - Request Method: 请求方法
    
    public func request(
        method: Method,
        urlString: String,
        complete: DataCompleteClosure? = nil)
        -> NSURLSessionDataTask
    {
        let urlRequest = buildURLRquest(method, urlString: urlString)
        return request(urlRequest, complete: complete)
    }
    
    public func request(
        method: Method,
        urlString: String,
        parameters: [String: AnyObject],
        complete: DataCompleteClosure? = nil)
        -> NSURLSessionDataTask
    {
        let urlRequest = buildURLRquest(method, urlString: urlString, parameters: parameters, encoding: .URL, timeout: 60)
        return request(urlRequest, complete: complete)
    }
    
    public func request(
        method: Method,
        urlString: String,
        parameters: [String: AnyObject],
        encoding: ParameterEncoding,
        complete: DataCompleteClosure? = nil)
        -> NSURLSessionDataTask
    {
        let urlRequest = buildURLRquest(method, urlString: urlString, parameters: parameters, encoding: encoding, timeout: 60)
        return request(urlRequest, complete: complete)
    }
    
    public func request(
        method: Method,
        urlString: String,
        parameters: [String: AnyObject],
        encoding: ParameterEncoding,
        timeout: NSTimeInterval,
        complete: DataCompleteClosure? = nil)
        -> NSURLSessionDataTask
    {
        let urlRequest = buildURLRquest(method, urlString: urlString, parameters: parameters, encoding: encoding, timeout: timeout)
        return request(urlRequest, complete: complete)
    }
    
    public func request(request: NSURLRequest, complete: DataCompleteClosure? = nil) -> NSURLSessionDataTask {
        let dataTask: NSURLSessionDataTask
        if let complete = complete {
            dataTask = session.dataTaskWithRequest(request) {
                complete($0, $1, $2)
            }
        } else {
            dataTask = session.dataTaskWithRequest(request)
        }
        
        dataTask.resume()
        return dataTask
    }
    
    // MARK: - 取消请求
    
    /**
    根据 NSURLSessionDataTask 来取消任务
    
    - parameter task: 要取消的任务，由 request(:) 方法返回
    */
    public func cancelDataTask(task: NSURLSessionDataTask) {
        task.cancel()
    }
    
    /**
     根据 NSURLSessionDownloadTask 来取消任务
     
     - parameter task: 要取消的任务，由 download() 方法返回
     */
    public func cancelDownloadTask(task: NSURLSessionDownloadTask) {
        task.cancel()
    }
    
    // MARK: - 下载
    
    public func downloadWithURL(url: NSURL, complete: DownloadCompleteClosure? = nil) -> NSURLSessionDownloadTask {
        let downloadTask: NSURLSessionDownloadTask
        if let complete = complete {
            downloadTask = session.downloadTaskWithURL(url) {
                complete($0, $1, $2)
            }
        } else {
            downloadTask = session.downloadTaskWithURL(url)
        }
        downloadTask.resume()
        return downloadTask
    }
    
    public func downloadWithRequest(request: NSURLRequest, complete: DownloadCompleteClosure? = nil) -> NSURLSessionDownloadTask {
        let downloadTask: NSURLSessionDownloadTask
        if let complete = complete {
            downloadTask = session.downloadTaskWithRequest(request) {
                complete($0, $1, $2)
            }
        } else {
            downloadTask = session.downloadTaskWithRequest(request)
        }
        downloadTask.resume()
        return downloadTask
    }
    
    // MARK: - 上传
    
    public func uploadTaskWithRequest(request: NSURLRequest, fromData: NSData, complete: DataCompleteClosure? = nil) -> NSURLSessionUploadTask {
        let uploadTask: NSURLSessionUploadTask
        if let complete = complete {
            uploadTask = session.uploadTaskWithRequest(request, fromData: fromData) {
                complete($0, $1, $2)
            }
        } else {
            uploadTask = session.uploadTaskWithRequest(request, fromData: fromData)
        }
        uploadTask.resume()
        return uploadTask
    }
    
    public func uploadTaskWithRequest(request: NSURLRequest, fromFile: NSURL, complete: DataCompleteClosure? = nil) -> NSURLSessionUploadTask {
        let uploadTask: NSURLSessionUploadTask
        if let complete = complete {
            uploadTask = session.uploadTaskWithRequest(request, fromFile: fromFile) {
                complete($0, $1, $2)
            }
        } else {
            uploadTask = session.uploadTaskWithRequest(request, fromFile: fromFile)
        }
        uploadTask.resume()
        return uploadTask
    }
    
}

