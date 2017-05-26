//
//  AlertCoordinator.swift
//  FuntastyKit
//
//  Created by Milan Strnad on 03/03/17.
//  Copyright © 2017 The Funtasty s.r.o. All rights reserved.
//

import UIKit

public final class AlertCoordinator {

    let parentViewController: UIViewController
    weak var viewController: UIAlertController?

    var error: Error?

    var title: String?
    var message: String?
    var actions: [UIAlertAction]?

    // MARK: - Inits

    public init(parent: UIViewController, error: Error) {
        self.parentViewController = parent
        self.error = error
    }

    public init(parent: UIViewController, title: String?, message: String?, actions: [UIAlertAction]? = [UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default)]) {
        self.parentViewController = parent
        self.title = title
        self.message = message
        self.actions = actions
    }
}

extension DefaultCoordinator {
    func navigateToAlert(for error: Error) {
        guard let viewController = self.viewController else {
            return
        }
        let alertCoordinator = AlertCoordinator(parent: viewController, error: error)
        alertCoordinator.start()
    }

    func navigateToAlert(title: String, message: String) {
        guard let viewController = self.viewController else {
            return
        }
        let alertCoordinator = AlertCoordinator(parent: viewController, title: title, message: message)
        alertCoordinator.start()
    }

    func navigateToAlert(title: String, message: String, actions: [UIAlertAction]?) {
        guard let viewController = self.viewController else {
            return
        }
        let alertCoordinator = AlertCoordinator(parent: viewController, title: title, message: message, actions: actions)
        alertCoordinator.start()
    }
}

public extension AlertCoordinator {
    func start() {
        var alert = UIAlertController()
        if let error = error {
            alert = UIAlertController(error: error)
        } else {
            alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            actions?.forEach(alert.addAction)
        }
        parentViewController.present(alert, animated: true, completion: nil)
        viewController = alert
    }

    func stop() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
