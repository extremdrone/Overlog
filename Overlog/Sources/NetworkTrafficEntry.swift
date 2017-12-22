//
//  NetworkTrafficEntry.swift
//
//  Copyright © 2017 Netguru Sp. z o.o. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import ResponseDetective

internal class NetworkTrafficEntry {
    var request: RequestRepresentation
    var response: ResponseRepresentation?
    var error: ErrorRepresentation?

    init(request: RequestRepresentation) {
        self.request = request
        self.response = nil
        self.error = nil
    }
    
    /// Returns host with path (eg. foo.bar/auth)
    internal var hostWithPath: String {
        guard let url = URL(string: request.urlString) else { return "" }
        return (url.host ?? "") + url.path
    }
    
    /// Indicates if entry is currently in progress
    internal var isInProgress: Bool {
        return response == nil
    }
    
    /// Indicates if entry has responded with success
    internal var responsedWithSuccess: Bool {
        guard let response = response else { return false }
        return 200 ..< 300 ~= response.statusCode
    }
    
    /// Status code with text representation
    internal var statusCodeWithTextRepresentation: String {
        guard let response = response else { return "" }
        return "\(response.statusCode) " + response.statusString
    }
}
