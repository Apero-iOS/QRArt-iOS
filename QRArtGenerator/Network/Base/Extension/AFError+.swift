//
//  AFError+.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 30/06/2023.
//

import Alamofire

extension AFError {
    
    var isTimeout: Bool {
        if isSessionTaskError,
           let error = underlyingError as NSError?,
           error.code == NSURLErrorTimedOut || error.code == NSURLErrorUnknown {
            return true
        }
        return false
    }
    
    var isConnectedToTheInternet: Bool {
        if isSessionTaskError,
           let error = underlyingError as NSError?,
           error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorDataNotAllowed {
            return true
        }
        return false
    }
}
