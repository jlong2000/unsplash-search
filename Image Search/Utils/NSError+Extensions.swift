//
//  NSError+Extensions.swift
//  Image Search
//
//  Created by Jiang Long on 6/6/21.
//

import Foundation

extension NSError {
    func isNoInternetConnectionError() -> Bool {
        let noInternetConnectionErrorCodes = [
            NSURLErrorNetworkConnectionLost,
            NSURLErrorNotConnectedToInternet,
            NSURLErrorInternationalRoamingOff,
            NSURLErrorCallIsActive,
            NSURLErrorDataNotAllowed
        ]

        if domain == NSURLErrorDomain && noInternetConnectionErrorCodes.contains(code) {
            return true
        }

        return false
    }
}
