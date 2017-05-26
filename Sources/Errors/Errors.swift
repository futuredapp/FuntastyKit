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
    public typealias ErrorHandler = () -> Void

    let title: String
    var action: ErrorHandler?

    public init(title: String, action: ErrorHandler? = nil) {
        self.title = title
        self.action = action
    }
}
