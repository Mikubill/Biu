//
//  RequestHandler.swift
//  Biu
//
//  Created by Ayari on 2019/09/30.
//  Copyright © 2019 Ayari. All rights reserved.
//

import Foundation
import Alamofire

class RequestHandler: RequestInterceptor {
    
    private var retriedRequests: [String: Int] = [:]
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (AFResult<URLRequest>) -> Void) {
        var modifiedURLRequest = urlRequest
        modifiedURLRequest.setValue(Constants.httpVia, forHTTPHeaderField: "Via")
        completion(.success(modifiedURLRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard
            request.task?.response == nil,
            let url = request.request?.url?.absoluteString
        else {
            removeCachedUrlRequest(url: request.request?.url?.absoluteString)
            completion(.doNotRetry)
            return
        }
        
        guard let retryCount = retriedRequests[url] else {
            retriedRequests[url] = 1
            completion(.retry)
            return
        }
        
        if retryCount <= 6 {
            retriedRequests[url] = retryCount + 1
            completion(.retry)
        } else {
            removeCachedUrlRequest(url: url)
            completion(.doNotRetry)
        }
    }
    
    private func removeCachedUrlRequest(url: String?) {
        guard let url = url else {
            return
        }
        retriedRequests.removeValue(forKey: url)
    }
    
}
