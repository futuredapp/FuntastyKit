import UIKit

public protocol Coordinator {
    /// Triggers navigation to the corresponding controller
    func start()

    /// Stops corresponding controller and returns back to previous one.
    ///
    /// This method is optional.
    func stop()
}

public extension Coordinator {
    func stop() {
    }
}

public protocol DefaultCoordinator: Coordinator {
    associatedtype ViewController: UIViewController
    var viewController: ViewController? { get }

    var animated: Bool { get }
    var delegate: CoordinatorDelegate? { get set }
}

public protocol ShowCoordinator: DefaultCoordinator {
    /// When used on Split View Controlelr as Detail View Controller, sourceViewController should be 'weak', otherwise memory leak will emerge
    var sourceViewController: UIViewController? { get }
    var isDetail: Bool { get }

    func configure(viewController: ViewController)
}

public protocol PushCoordinator: DefaultCoordinator {
    func configure(viewController: ViewController)
    var navigationController: UINavigationController { get }
}

public protocol ModalCoordinator: DefaultCoordinator {
    func configure(viewController: ViewController)
    var sourceViewController: UIViewController { get }
    var destinationNavigationController: UINavigationController? { get }
}

public protocol TabBarItemCoordinator: DefaultCoordinator {
    func configure(viewController: ViewController)
    var tabBarController: UITabBarController? { get }
    var destinationNavigationController: UINavigationController? { get }
}

public extension DefaultCoordinator {
    // default implementation if not overriden
    var animated: Bool {
        return true
    }

    // default implementation of nil delegate, should be overriden when needed
    var delegate: CoordinatorDelegate? {
        get {
            return nil
        }
        // swiftlint:disable:next unused_setter_value
        set {
        }
    }

    func stop() {
        delegate?.willStop(in: self)
        delegate?.didStop(in: self)
    }
}

public extension ShowCoordinator {
    var isDetail: Bool {
        return false
    }

    func start() {
        guard let viewController = viewController else {
            return
        }
        configure(viewController: viewController)
        if isDetail {
            sourceViewController?.showDetailViewController(viewController, sender: nil)
        } else {
            sourceViewController?.show(viewController, sender: nil)
        }
    }
}

public extension PushCoordinator {
    func start() {
        guard let viewController = viewController else {
            return
        }

        configure(viewController: viewController)
        navigationController.pushViewController(viewController, animated: animated)
    }

    func stop() {
        delegate?.willStop(in: self)
        navigationController.popViewController(animated: animated)
        delegate?.didStop(in: self)
    }
}

public extension ModalCoordinator {
    func start() {
        guard let viewController = viewController else {
            return
        }

        configure(viewController: viewController)

        if let destinationNavigationController = destinationNavigationController {
            // wrapper navigation controller given, present it
            sourceViewController.present(destinationNavigationController, animated: animated, completion: nil)
        } else {
            // no wrapper navigation controller given, present actual controller
            sourceViewController.present(viewController, animated: animated, completion: nil)
        }
    }

    func stop() {
        delegate?.willStop(in: self)
        viewController?.dismiss(animated: animated) {
            self.delegate?.didStop(in: self)
        }
    }
}

public extension TabBarItemCoordinator {
    func start() {
        guard let viewController = viewController else {
            return
        }
        configure(viewController: viewController)

        var viewControllers = tabBarController?.viewControllers ?? []
        viewControllers.append(destinationNavigationController ?? viewController)

        tabBarController?.setViewControllers(viewControllers, animated: animated)
    }

    func stop() {
        delegate?.willStop(in: self)
        guard let viewController = viewController, let viewControllers = tabBarController?.viewControllers else {
            return
        }

        var mutableViewControllers = viewControllers
        if let index = mutableViewControllers.firstIndex(of: destinationNavigationController ?? viewController) {
            mutableViewControllers.remove(at: index)
        }

        tabBarController?.setViewControllers(mutableViewControllers, animated: animated)
        delegate?.didStop(in: self)
    }
}

public protocol CoordinatorDelegate: class {
    func willStop(in coordinator: Coordinator)
    func didStop(in coordinator: Coordinator)
}
