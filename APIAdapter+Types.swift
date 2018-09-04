//
//  APIAdapter+Types.swift
//  FuntastyKit
//
//  Created by Matěj Jirásek on 08/02/2018.
//  Copyright © 2018 FUNTASTY Digital s.r.o. All rights reserved.
//

import Foundation

// MARK: - API adapter error

public enum APIAdapterError: Error {
    case noResponse
    case errorCode(Int, Data?)
}

// MARK: - API result

public enum APIResult<T> {
    case value(T)
    case error(Error)
}

// MARK: - HTTP methods

public enum HTTPMethod: String, CustomStringConvertible {
    case options, get, head, post, put, patch, delete, trace, connect

    public var description: String {
        return rawValue.uppercased()
    }
}

// MARK: - API request types

public typealias Parameters = [String: String]
public typealias HTTPHeaders = [String: String]

public enum RequestData {
    case urlEncoded(Parameters)
    case jsonParams(Parameters)
    case jsonBody(Encodable)
    case json(body: Data, query: Parameters)
    case multipart(Parameters, Data?)
    case base64Upload(Parameters)

    static let empty: RequestData = .jsonParams([:])
}
