import UIKit

public protocol Coordinator {
    /// Triggers navigation to the corresponding controller
    func start()

    /// Stops corresponding controller and returns back to previous one.
    ///
    /// This method is optional.
    func stop()
}

extension Coordinator {
    public func stop() {}
}

public protocol DefaultCoordinator: Coordinator {
    associatedtype ViewController: UIViewController

    var viewController: ViewController? { get }
    var animated: Bool { get }
    var delegate: (any CoordinatorDelegate)? { get set }
}

public protocol ConfiguringCoordinator: DefaultCoordinator {
    func configure(viewController: ViewController)
}

public protocol ShowCoordinator: ConfiguringCoordinator {
    /// When used on Split View Controller as Detail View Controller, sourceViewController should be 'weak', otherwise memory leak will emerge
    var sourceViewController: UIViewController? { get }
    var isDetail: Bool { get }
}

public protocol PushCoordinator: ConfiguringCoordinator {
    var navigationController: UINavigationController? { get }
}

public protocol ModalCoordinator: ConfiguringCoordinator {
    var sourceViewController: UIViewController { get }
    var destinationNavigationController: UINavigationController? { get }
}

public protocol TabBarItemCoordinator: ConfiguringCoordinator {
    var tabBarController: UITabBarController? { get }
    var destinationNavigationController: UINavigationController? { get }
}

extension DefaultCoordinator {
    // default implementation if not overridden
    public var animated: Bool {
        true
    }

    // default implementation of nil delegate, should be overridden when needed
    public var delegate: (any CoordinatorDelegate)? {
        get {
            nil
        }
        // swiftlint:disable:next unused_setter_value
        set {
        }
    }

    public func stop() {
        delegate?.willStop(in: self)
        delegate?.didStop(in: self)
    }
}

extension ShowCoordinator {
    public var isDetail: Bool {
        false
    }

    public func start() {
        guard let viewController else { return }

        configure(viewController: viewController)
        if isDetail {
            sourceViewController?.showDetailViewController(viewController, sender: nil)
        } else {
            sourceViewController?.show(viewController, sender: nil)
        }
    }
}

extension PushCoordinator {
    public func start() {
        guard let viewController else { return }

        configure(viewController: viewController)
        navigationController?.pushViewController(viewController, animated: animated)
    }

    public func stop() {
        delegate?.willStop(in: self)
        navigationController?.popViewController(animated: animated)
        delegate?.didStop(in: self)
    }
}

extension ModalCoordinator {
    public var destinationNavigationController: UINavigationController? { nil }

    public func start() {
        guard let viewController else { return }

        configure(viewController: viewController)

        if let destinationNavigationController {
            // wrapper navigation controller given, present it
            sourceViewController.present(destinationNavigationController, animated: animated)
        } else {
            // no wrapper navigation controller given, present actual controller
            sourceViewController.present(viewController, animated: animated)
        }
    }

    public func stop() {
        delegate?.willStop(in: self)
        viewController?.dismiss(animated: animated) {
            self.delegate?.didStop(in: self)
        }
    }
}

extension TabBarItemCoordinator {
    public var destinationNavigationController: UINavigationController? { nil }

    public func start() {
        guard let viewController else { return }

        configure(viewController: viewController)

        var viewControllers = tabBarController?.viewControllers ?? []
        viewControllers.append(destinationNavigationController ?? viewController)

        tabBarController?.setViewControllers(viewControllers, animated: animated)
    }

    public func stop() {
        delegate?.willStop(in: self)

        guard let viewController, let viewControllers = tabBarController?.viewControllers else { return }

        var mutableViewControllers = viewControllers
        if let index = mutableViewControllers.firstIndex(of: destinationNavigationController ?? viewController) {
            mutableViewControllers.remove(at: index)
        }

        tabBarController?.setViewControllers(mutableViewControllers, animated: animated)
        delegate?.didStop(in: self)
    }
}

public protocol CoordinatorDelegate: AnyObject {
    func willStop(in coordinator: any Coordinator)
    func didStop(in coordinator: any Coordinator)
}
