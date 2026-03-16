import UIKit

public class AlertCoordinator: DefaultCoordinator {
    public typealias ViewController = UIAlertController

    public enum Source: Sendable {
        case button(UIBarButtonItem)
        case view(UIView)
    }

    public enum Style: Sendable {
        case alert
        case actionSheet(source: Source?)

        var controllerStyle: UIAlertController.Style {
            switch self {
            case .alert:
                return .alert
            case .actionSheet:
                return .actionSheet
            }
        }
    }

    enum InputType {
        case error(any Error)
        case custom(title: String?, message: String?, actions: [ErrorAction]?)

        func alertController(preferredStyle: Style = .alert) -> UIAlertController {
            switch self {
            case .error(let error):
                return UIAlertController(error: error, preferredStyle: preferredStyle.controllerStyle)
            case let .custom(title, message, actions):
                let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle.controllerStyle)
                (actions ?? [ErrorAction(title: NSLocalizedString("OK", comment: "OK"))])
                    .forEach { action in
                        let alertAction = action.alertAction()
                        alert.addAction(alertAction)
                        if action.style == .preferred {
                            alert.preferredAction = alertAction
                        }
                    }
                return alert
            }
        }
    }

    let parentViewController: UIViewController
    public weak var viewController: UIAlertController?
    public weak var delegate: (any CoordinatorDelegate)?

    private var type: InputType
    private var preferredStyle: Style

    // MARK: - Inits

    public init(parent: UIViewController, error: any Error, preferredStyle: Style = .alert) {
        self.parentViewController = parent
        self.type = .error(error)
        self.preferredStyle = preferredStyle
    }

    public init(parent: UIViewController, title: String?, message: String?, actions: [ErrorAction]? = nil, preferredStyle: Style = .alert) {
        self.parentViewController = parent
        self.type = .custom(title: title, message: message, actions: actions)
        self.preferredStyle = preferredStyle
    }

    public func start() {
        let alert = type.alertController(preferredStyle: preferredStyle)
        if case .actionSheet(let source) = preferredStyle, let sourceView = source {
            switch sourceView {
            case .button(let button):
                alert.popoverPresentationController?.barButtonItem = button
            case .view(let view):
                alert.popoverPresentationController?.sourceView = view
            }
        }
        parentViewController.present(alert, animated: animated, completion: nil)
        viewController = alert
    }

    public func stop() {
        delegate?.willStop(in: self)
        viewController?.dismiss(animated: animated) {
            self.delegate?.didStop(in: self)
        }
    }
}

extension ErrorAction {
    public func alertStyle() -> UIAlertAction.Style {
        switch self.style {
        case .cancel:
            return .cancel
        case .destructive:
            return .destructive
        default:
            return .default
        }
    }

    public func alertAction() -> UIAlertAction {
        UIAlertAction(title: self.title, style: self.alertStyle()) { _ in
            self.action?()
        }
    }
}

extension DefaultCoordinator {
    public func showAlert(for error: any Error, preferredStyle: AlertCoordinator.Style = .alert) {
        guard let viewController = self.viewController else {
            return
        }

        let alertCoordinator = AlertCoordinator(parent: viewController, error: error, preferredStyle: preferredStyle)
        alertCoordinator.start()
    }

    public func showAlert(title: String?, message: String?, actions: [ErrorAction]? = nil, preferredStyle: AlertCoordinator.Style = .alert) {
        guard let viewController = self.viewController else {
            return
        }

        let alertCoordinator = AlertCoordinator(parent: viewController, title: title, message: message, actions: actions, preferredStyle: preferredStyle)
        alertCoordinator.start()
    }
}
