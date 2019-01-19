//
//  WebService.swift
//  Cake List
//
//  Created by Angelo Gkiata on 19/01/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

import Foundation
let CacheTime = "cache_time"
public typealias CompletionHandler<T: Codable> = (T?, Error?) -> Void
@objc class WebService: NSObject {
    
    func uRLSession(endpoint: String?, completionHandler: @escaping (_ data: Data?, _ error: Error?) -> ()) {
        guard let endpoint = endpoint else { return }
        guard let url = URL(string: endpoint) else {
            print("Error: cannot create URL")
            completionHandler(nil, nil)
            return
        }
        let urlRequest = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            completionHandler(data, error)
        }
        task.resume()
    }
    
    @discardableResult
    func performURLSession<T: Codable> (codableType: T.Type, endpoint: String?, completionHandler: @escaping CompletionHandler<T>) -> URLSessionDataTask? {
        guard let endpoint = endpoint else {
            completionHandler(nil, nil)
            return nil
        }
        guard let url = URL(string: endpoint) else {
            print("Error: cannot create URL")
            completionHandler(nil, nil)
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 60
        if let response = cachedResponse(request: urlRequest) {
            self.handleResponseData(codableType: codableType,
                                    fromCache: true,
                                    request: urlRequest,
                                    response: response.response,
                                    data: response.data,
                                    error: nil,
                                    completionHandler: completionHandler)
            return nil
        }
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            self.handleResponseData(codableType: codableType,
                                    fromCache: false,
                                    request: urlRequest,
                                    response: response,
                                    data: data,
                                    error: error,
                                    completionHandler: completionHandler)
        }
        task.resume()
        return task
    }
    
    private func handleResponseData<T: Codable> (codableType: T.Type, fromCache: Bool, request: URLRequest, response: URLResponse?, data: Data?, error: Error?, completionHandler: @escaping CompletionHandler<T>) {
        guard error == nil else {
            print(error!)
            completionHandler(nil, error)
            return
        }
        if let responseData = data {
            do {
                let responseModel = try JSONDecoder().decode(codableType.self, from: responseData)
                completionHandler(responseModel, nil)
                if !fromCache {
                    cacheResponse(response: response, data: data, request: request)
                }
                return
            } catch {
                completionHandler(nil, error)
            }
        }
    }
    
    private func cacheResponse(response: URLResponse?, data: Data?, request: URLRequest) {
        if let response = response, let data = data {
            let userInfo = ["cache_time": NSDate()]
            let cachedResponse = CachedURLResponse(response: response, data: data, userInfo: userInfo, storagePolicy: .allowed)
            URLCache.shared.storeCachedResponse(cachedResponse, for: request)
        }
    }
    
    private func cachedResponse(request: URLRequest) -> CachedURLResponse? {
        if let response = URLCache.shared.cachedResponse(for: request) {
            if let userInfo = response.userInfo {
                if let cacheDate = userInfo[CacheTime] as? NSDate {
                    if (cacheDate.timeIntervalSinceNow <  -(60*4)) {
                        URLCache.shared.removeCachedResponse(for: request);
                    } else {
                        return response
                    }
                }
            }
        }
        return nil
    }
}
