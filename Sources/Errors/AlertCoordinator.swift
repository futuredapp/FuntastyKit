//
//  AlertCoordinator.swift
//  FuntastyKit
//
//  Created by Milan Strnad on 03/03/17.
//  Copyright © 2017 The Funtasty s.r.o. All rights reserved.
//

import UIKit

public class AlertCoordinator: ModalCoordinator {
    public enum Source {
        case button(UIBarButtonItem)
        case view(UIView)
    }

    public enum Style {
        case alert
        case actionSheet(source: Source?)

        var controllerStyle: UIAlertControllerStyle {
            switch self {
            case .alert:
                return .alert
            case .actionSheet:
                return .actionSheet
            }
        }
    }

    enum InputType {
        case error(Error)
        case custom(title: String?, message: String?, actions: [ErrorAction])
    }

    public let sourceViewController: UIViewController
    public var destinationNavigationController: UINavigationController?
    public weak var viewController: UIAlertController?
    public weak var delegate: CoordinatorDelegate?

    private let type: InputType
    private let preferredStyle: Style

    // MARK: - Inits

    public init(parent: UIViewController, error: Error, preferredStyle: Style = .alert) {
        self.sourceViewController = parent
        self.type = .error(error)
        self.preferredStyle = preferredStyle
    }

    public init(parent: UIViewController, title: String?, message: String?, actions: [ErrorAction] = [], preferredStyle: Style = .alert) {
        self.sourceViewController = parent
        self.type = .custom(title: title, message: message, actions: actions)
        self.preferredStyle = preferredStyle
    }

    public func configure(viewController: UIAlertController) {
        configure(viewController: viewController, preferredStyle: preferredStyle)

        switch type {
        case let .custom(title, message, actions):
            viewController.title = title
            viewController.message = message
            configure(viewController: viewController, actions: actions)
        case let .error(error):
            configure(viewController: viewController, error: error)
        }
    }

    private func configure(viewController: UIAlertController, preferredStyle: Style) {
        if case .actionSheet(let source) = preferredStyle, let sourceView = source {
            switch sourceView {
            case .button(let button):
                viewController.popoverPresentationController?.barButtonItem = button
            case .view(let view):
                viewController.popoverPresentationController?.sourceView = view
            }
        }
    }

    private func configure(viewController: UIAlertController, error: Error) {
        switch error {
        case let error as ResolvableError:
            viewController.title = error.errorDescription ?? NSLocalizedString("Error", comment: "Error")
            viewController.message = error.failureReason ?? error.localizedDescription
            configure(viewController: viewController, actions: error.actions)
        case let error as LocalizedError:
            viewController.title = error.errorDescription ?? NSLocalizedString("Error", comment: "Error")
            viewController.message = error.failureReason ?? error.localizedDescription
            configure(viewController: viewController, actions: [])
        default:
            viewController.title = NSLocalizedString("Error", comment: "Error")
            viewController.message = error.localizedDescription
            configure(viewController: viewController, actions: [])
        }
    }

    private func configure(viewController: UIAlertController, actions: [ErrorAction]) {
        let okAction = ErrorAction(title: NSLocalizedString("OK", comment: "OK"))
        let allActions = actions.isEmpty ? [okAction] : actions
        allActions.forEach { viewController.addAction($0.alertAction()) }
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
    public func showAlert(for error: Error, preferredStyle: AlertCoordinator.Style = .alert) {
        guard let viewController = self.viewController else {
            return
        }

        let alertCoordinator = AlertCoordinator(parent: viewController, error: error, preferredStyle: preferredStyle)
        alertCoordinator.start()
    }

    public func showAlert(title: String?, message: String?, actions: [ErrorAction] = [], preferredStyle: AlertCoordinator.Style = .alert) {
        guard let viewController = self.viewController else {
            return
        }

        let alertCoordinator = AlertCoordinator(parent: viewController, title: title, message: message, actions: actions, preferredStyle: preferredStyle)
        alertCoordinator.start()
    }
}
