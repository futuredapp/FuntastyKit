//
//  UIAlertController+Error.swift
//  FuntastyKit
//
//  Created by Milan Strnad on 03/03/17.
//  Copyright © 2017 The Funtasty s.r.o. All rights reserved.
//

import UIKit

public extension UIAlertController {
    convenience init(error: Error, preferredStyle: UIAlertControllerStyle = .alert) {
        switch error {
        case let error as ResolvableError:
            self.init(title: error.errorDescription ?? NSLocalizedString("Error", comment: "Error"), message: error.failureReason ?? error.localizedDescription, preferredStyle: preferredStyle)
            error.actions.map { $0.alertAction() }.forEach(self.addAction)
            if error.actions.isEmpty {
                self.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default))
            }
        case let error as LocalizedError:
            self.init(title: error.errorDescription ?? NSLocalizedString("Error", comment: "Error"), message: error.failureReason ?? error.localizedDescription, preferredStyle: preferredStyle)
            self.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default))
        default:
            self.init(title: NSLocalizedString("Error", comment: "Error"), message: error.localizedDescription, preferredStyle: preferredStyle)
            self.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default))
        }
    }
}
