//
//  ParameterEncoding.swift
//  IWILLKit
//
//  Created by Lynch Wong on 12/31/15. Come from Alamofire's ParameterEncoding.
//  Copyright © 2015 Lynch Wong. All rights reserved.
//

import Foundation

/**
 定义HTTP
 
 - OPTIONS: OPTIONS
 - GET:     GET
 - HEAD:    HEAD
 - POST:    POST
 - PUT:     PUT
 - PATCH:   PATCH
 - DELETE:  DELETE
 - TRACE:   TRACE
 - CONNECT: CONNECT
 */
public enum Method: String {
    case OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
}

// MARK: - URLRequestConvertible

public protocol URLRequestConvertible {
    var URLRequest: NSMutableURLRequest { get }
}

extension NSURLRequest: URLRequestConvertible {
    public var URLRequest: NSMutableURLRequest {
        return mutableCopy() as! NSMutableURLRequest
    }
}

// MARK: - ParameterEncoding

/**
 ParameterEncoding
 */
public enum ParameterEncoding {
    case URL
    case URLEncodedInURL
    case JSON
    case PropertyList(NSPropertyListFormat, NSPropertyListWriteOptions)
    case Custom((URLRequestConvertible, [String: AnyObject]?) -> (NSMutableURLRequest, NSError?))
    
    /**
     Creates a URL request by encoding parameters and applying them onto an existing request.
     
     - parameter URLRequest: The request to have parameters applied
     - parameter parameters: The parameters to apply
     
     - returns: A tuple containing the constructed request and the error that occurred during parameter encoding,
     if any.
     */
    public func encode(URLRequest: URLRequestConvertible, parameters: [String: AnyObject]?) -> NSMutableURLRequest {
        var mutableURLRequest = URLRequest.URLRequest
        
        guard let parameters = parameters where !parameters.isEmpty else {
            return mutableURLRequest
        }
        
        var encodingError: NSError? = nil
        
        switch self {
        case .URL, .URLEncodedInURL:
            func query(parameters: [String: AnyObject]) -> String {
                var components: [(String, String)] = []
                
                for key in parameters.keys.sort(<) {
                    let value = parameters[key]!
                    components += queryComponents(key, value)
                }
                
                return (components.map { "\($0)=\($1)" } as [String]).joinWithSeparator("&")
            }
            
            func encodesParametersInURL(method: Method) -> Bool {
                switch self {
                case .URLEncodedInURL:
                    return true
                default:
                    break
                }
                
                switch method {
                case .GET, .HEAD, .DELETE:
                    return true
                default:
                    return false
                }
            }
            
            if let method = Method(rawValue: mutableURLRequest.HTTPMethod) where encodesParametersInURL(method) {
                if let URLComponents = NSURLComponents(URL: mutableURLRequest.URL!, resolvingAgainstBaseURL: false) {
                    let percentEncodedQuery = (URLComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters)
                    URLComponents.percentEncodedQuery = percentEncodedQuery
                    mutableURLRequest.URL = URLComponents.URL
                }
            } else {
                if mutableURLRequest.valueForHTTPHeaderField("Content-Type") == nil {
                    mutableURLRequest.setValue(
                        "application/x-www-form-urlencoded; charset=utf-8",
                        forHTTPHeaderField: "Content-Type"
                    )
                }
                
                mutableURLRequest.HTTPBody = query(parameters).dataUsingEncoding(
                    NSUTF8StringEncoding,
                    allowLossyConversion: false
                )
            }
        case .JSON:
            do {
                let options = NSJSONWritingOptions()
                let data = try NSJSONSerialization.dataWithJSONObject(parameters, options: options)
                
                mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                mutableURLRequest.HTTPBody = data
            } catch {
                encodingError = error as NSError
            }
        case .PropertyList(let format, let options):
            do {
                let data = try NSPropertyListSerialization.dataWithPropertyList(
                    parameters,
                    format: format,
                    options: options
                )
                mutableURLRequest.setValue("application/x-plist", forHTTPHeaderField: "Content-Type")
                mutableURLRequest.HTTPBody = data
            } catch {
                encodingError = error as NSError
            }
        case .Custom(let closure):
            (mutableURLRequest, encodingError) = closure(mutableURLRequest, parameters)
        }
        
        return mutableURLRequest
    }
    
    /**
     Creates percent-escaped, URL encoded query string components from the given key-value pair using recursion.
     
     - parameter key:   The key of the query component.
     - parameter value: The value of the query component.
     
     - returns: The percent-escaped, URL encoded query string components.
     */
    public func queryComponents(key: String, _ value: AnyObject) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: AnyObject] {
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [AnyObject] {
            for value in array {
                components += queryComponents("\(key)[]", value)
            }
        } else {
            components.append((escape(key), escape("\(value)")))
        }
        
        return components
    }
    
    /**
     Returns a percent-escaped string following RFC 3986 for a query string key or value.
     
     RFC 3986 states that the following characters are "reserved" characters.
     
     - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
     - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
     
     In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
     query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
     should be percent-escaped in the query string.
     
     - parameter string: The string to be percent-escaped.
     
     - returns: The percent-escaped string.
     */
    public func escape(string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        let allowedCharacterSet = NSCharacterSet.URLQueryAllowedCharacterSet().mutableCopy() as! NSMutableCharacterSet
        allowedCharacterSet.removeCharactersInString(generalDelimitersToEncode + subDelimitersToEncode)
        
        var escaped = ""
        
        //==========================================================================================================
        //
        //  Batching is required for escaping due to an internal bug in iOS 8.1 and 8.2. Encoding more than a few
        //  hundred Chinense characters causes various malloc error crashes. To avoid this issue until iOS 8 is no
        //  longer supported, batching MUST be used for encoding. This introduces roughly a 20% overhead. For more
        //  info, please refer to:
        //
        //      - https://github.com/Alamofire/Alamofire/issues/206
        //
        //==========================================================================================================
        
        if #available(iOS 8.3, OSX 10.10, *) {
            escaped = string.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet) ?? string
        } else {
            let batchSize = 50
            var index = string.startIndex
            
            while index != string.endIndex {
                let startIndex = index
                let endIndex = index.advancedBy(batchSize, limit: string.endIndex)
                let range = Range(start: startIndex, end: endIndex)
                
                let substring = string.substringWithRange(range)
                
                escaped += substring.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet) ?? substring
                
                index = endIndex
            }
        }
        
        return escaped
    }
}