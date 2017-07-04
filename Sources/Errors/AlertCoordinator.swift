//
//  AlertCoordinator.swift
//  FuntastyKit
//
//  Created by Milan Strnad on 03/03/17.
//  Copyright © 2017 The Funtasty s.r.o. All rights reserved.
//

import UIKit

public class AlertCoordinator: DefaultCoordinator {
    enum InputType {
        case error(Error)
        case custom(title: String, message: String?, actions: [ErrorAction]?)

        func alertController() -> UIAlertController {
            switch self {
            case .error(let error):
                return UIAlertController(error: error)
            case .custom(let title, let message, let actions):
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                actions?.map { $0.alertAction() }.forEach(alert.addAction)
                return alert
            }
        }
    }

    let parentViewController: UIViewController
    public weak var viewController: UIAlertController?

    private var type: InputType

    // MARK: - Inits

    public init(parent: UIViewController, error: Error) {
        self.parentViewController = parent
        self.type = .error(error)
    }

    public init(parent: UIViewController, title: String, message: String?, actions: [ErrorAction] = [ErrorAction(title: NSLocalizedString("OK", comment: "OK"))]) {
        self.parentViewController = parent
        self.type = .custom(title: title, message: message, actions: actions)
    }

    public func start() {
        let alert = type.alertController()
        parentViewController.present(alert, animated: animated, completion: nil)
        viewController = alert
    }

    public func stop() {
        delegate?.willStop(in: self)
        viewController?.dismiss(animated: animated, completion: nil)
        delegate?.didStop(in: self)
    }
}

public extension ErrorAction {
    func alertStyle() -> UIAlertActionStyle {
        switch self.style {
        case .default:
            return .default
        case .cancel:
            return .cancel
        case .destructive:
            return .destructive
        }
    }

    func alertAction() -> UIAlertAction {
        return UIAlertAction(title: self.title, style: self.alertStyle(), handler: { _ in self.action?() })
    }
}

public extension DefaultCoordinator {
    public func showAlert(for error: Error) {
        guard let viewController = self.viewController else {
            return
        }

        let alertCoordinator = AlertCoordinator(parent: viewController, error: error)
        alertCoordinator.start()
    }

    public func showAlert(title: String, message: String, actions: [ErrorAction]? = nil) {
        guard let viewController = self.viewController else {
            return
        }

        var alertCoordinator: AlertCoordinator
        if let actions = actions {
            alertCoordinator = AlertCoordinator(parent: viewController, title: title, message: message, actions: actions)
        } else {
            alertCoordinator = AlertCoordinator(parent: viewController, title: title, message: message)
        }
        alertCoordinator.start()
    }
}
