//
//  UIAlertController+Error.swift
//  FuntastyKit
//
//  Created by Milan Strnad on 03/03/17.
//  Copyright © 2017 The Funtasty s.r.o. All rights reserved.
//

import UIKit

public extension UIAlertController {
    convenience init(error: Error) {
        switch error {
        case let error as ResolvableError:
            self.init(title: error.errorDescription ?? NSLocalizedString("Error", comment: "Error"), message: error.failureReason ?? error.localizedDescription, preferredStyle: .alert)
            error.actions.forEach { errorAction in
                let action = UIAlertAction(title: errorAction.title, style: .default, handler: { _ in
                    errorAction.action?()
                })
                self.addAction(action)
            }
            if error.actions.isEmpty {
                self.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default))
            }
        case let error as LocalizedError:
            self.init(title: error.errorDescription ?? NSLocalizedString("Error", comment: "Error"), message: error.failureReason ?? error.localizedDescription, preferredStyle: .alert)
            self.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default))
        default:
            self.init(title: NSLocalizedString("Error", comment: "Error"), message: error.localizedDescription, preferredStyle: .alert)
            self.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default))
        }
    }
}
