//
//  APIAdapter+Types.swift
//  FuntastyKit
//
//  Created by Matěj Jirásek on 08/02/2018.
//  Copyright © 2018 FUNTASTY Digital s.r.o. All rights reserved.
//

import Foundation

// MARK: - API Result

enum APIResult<T> {
    case value(T)
    case error(Error)
}

// MARK: - HTTP methods

enum HTTPMethod: String {
    case options, get, head, post, put, patch, delete, trace, connect
}

extension HTTPMethod: CustomStringConvertible {
    var description: String {
        return rawValue.uppercased()
    }
}

// MARK: - API request types

typealias Parameters = [String: String]
typealias HTTPHeaders = [String: String]

enum RequestData {
    case urlEncoded(Parameters)
    case jsonParams(Parameters)
    case jsonBody(Encodable)
    case json(body: Data, query: Parameters)
    case multipart(Parameters, Data?)
    case base64Upload(Parameters)

    static let empty: RequestData = .jsonParams([:])
}

// MARK: - API endpoint definition protocol

protocol APIEndpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var data: RequestData { get }
    var authorized: Bool { get }
}

extension APIEndpoint {
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

protocol APIResponseEndpoint: APIEndpoint {
    associatedtype Response: Decodable
}

protocol APIRequestEndpoint: APIEndpoint {
    init(data: RequestData)
}

extension APIRequestEndpoint {
    init(request: Encodable) {
        self.init(data: .jsonBody(request))
    }

    var method: HTTPMethod {
        return .post
    }
}

typealias APIRequestResponseEndpoint = APIRequestEndpoint & APIResponseEndpoint

// MARK: - Foundation type extensions

extension URL {
    mutating func appendQuery(parameters: [String: String]) {
        self = appendingQuery(parameters: parameters)
    }

    func appendingQuery(parameters: [String: String]) -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        let oldItems = components?.queryItems ?? []
        components?.queryItems = oldItems + parameters.map(URLQueryItem.init)
        return components?.url ?? self
    }
}

extension Data {
    mutating func append(_ string: String) {
        append(Data(string.utf8))
    }

    mutating func appendRow(_ string: String? = nil) {
        if let string = string {
            append(string)
        }
        append("\r\n")
    }
}
