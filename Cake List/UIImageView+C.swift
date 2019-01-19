//
//  UIImageView+C.swift
//  Cake List
//
//  Created by Angelo Gkiata on 19/01/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

import Foundation
import UIKit

@objc extension UIImageView {
    @discardableResult
    @objc  func loadImage(urlString: String) -> URLSessionDataTask? {
        guard let url = URL(string: urlString) else { return nil }
        let urlRequest = URLRequest(url: url)
        self.contentMode = .scaleAspectFill
        if let response = URLCache.shared.cachedResponse(for: urlRequest) {
            if let userInfo = response.userInfo {
                if let cacheDate = userInfo[CacheTime] as? NSDate {
                    if (cacheDate.timeIntervalSinceNow <  -(60 * 100)) {
                        URLCache.shared.removeCachedResponse(for: urlRequest);
                    } else {
                        let data = response.data
                        let image = UIImage(data: data)
                        DispatchQueue.main.async() {
                            self.image = image
                        }
                        return nil
                    }
                }
            }
        }
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse,
                httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data) else {
                    DispatchQueue.main.async() {
                        self.image = UIImage(named: "placeholder_thumb")
                    }
                    return
            }
            self.cacheResponse(response: response, data: data, request: urlRequest)
            DispatchQueue.main.async() {
                self.image = image
            }
        }
        task.resume()
        return task
    }
    
    private func cacheResponse(response: URLResponse?, data: Data?, request: URLRequest) {
        if let response = response, let data = data {
            let userInfo = ["cache_time": NSDate()]
            let cachedResponse = CachedURLResponse(response: response, data: data, userInfo: userInfo, storagePolicy: .allowed)
            URLCache.shared.storeCachedResponse(cachedResponse, for: request)
        }
    }
}
