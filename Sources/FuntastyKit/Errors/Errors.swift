//
//  Errors.swift
//  FuntastyKit
//
//  Created by Milan Strnad on 03/03/17.
//  Copyright © 2017 The Funtasty s.r.o. All rights reserved.
//

import Foundation

public protocol ResolvableError: LocalizedError {
    var actions: [ErrorAction] { get }
}

public struct ErrorAction {
    public enum Style: Int {
        case `default`
        case cancel
        case destructive
        case preferred
    }

    public typealias ErrorHandler = () -> Void

    let title: String
    var action: ErrorHandler?
    var style: Style

    public init(title: String, style: Style = .default, action: ErrorHandler? = nil) {
        self.title = title
        self.style = style
        self.action = action
    }
}
