//
//  APIEndpoint.swift
//  FuntastyKit-iOS
//
//  Created by Matěj Kašpar Jirásek on 04/09/2018.
//  Copyright © 2018 The Funtasty. All rights reserved.
//

import Foundation

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
