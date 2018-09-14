//
//  Data+APIAdapter.swift
//  FuntastyKit-iOS
//
//  Created by Matěj Kašpar Jirásek on 03/09/2018.
//  Copyright © 2018 The Funtasty. All rights reserved.
//

import Foundation

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
