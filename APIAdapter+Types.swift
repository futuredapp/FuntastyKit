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

// MARK: - API endpoint protocols

public protocol APIEndpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var data: RequestData { get }
    var authorized: Bool { get }
}

public extension APIEndpoint {
    var data: RequestData {
        return .empty
    }

    var method: HTTPMethod {
        return .get
    }

    var authorized: Bool {
        return false
    }
}

public protocol APIResponseEndpoint: APIEndpoint {
    associatedtype Response: Decodable
}

public protocol APIRequestEndpoint: APIEndpoint {
    init(data: RequestData)
}

public extension APIRequestEndpoint {
    init(request: Encodable) {
        self.init(data: .jsonBody(request))
    }

    var method: HTTPMethod {
        return .post
    }
}

public typealias APIRequestResponseEndpoint = APIRequestEndpoint & APIResponseEndpoint
