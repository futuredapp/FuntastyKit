//
//  UIAlertController+Error.swift
//  FuntastyKit
//
//  Created by Milan Strnad on 03/03/17.
//  Copyright © 2017 The Funtasty s.r.o. All rights reserved.
//

import UIKit

public extension UIAlertController {
    convenience init(error: Error, preferredStyle: UIAlertController.Style = .alert) {
        self.init(title: UIAlertController.alertTitle(error: error),
                  message: UIAlertController.alertMessage(error: error),
                  preferredStyle: preferredStyle)
        if let error = error as? ResolvableError {
            error.actions.map { $0.alertAction() }.forEach(self.addAction)
            if !error.actions.isEmpty {
                return
            }
        }
        self.addAction(UIAlertAction(title: UIAlertController.okButtonText, style: .default))
    }

    private static func alertTitle(error: Error) -> String {
        switch error {
        case let error as LocalizedError:
            return error.errorDescription ?? defaultErrorTitle
        default:
            return defaultErrorTitle
        }
    }

    private static func alertMessage(error: Error) -> String {
        switch error {
        case let error as LocalizedError:
            return error.failureReason ?? error.localizedDescription
        default:
            return error.localizedDescription
        }
    }

    private static var defaultErrorTitle: String {
        return NSLocalizedString("Error", comment: "Error")
    }

    private static var okButtonText: String {
        return NSLocalizedString("OK", comment: "OK")
    }
}
