//
//  Coordinator.swift
//  FuntastyKit
//
//  Created by Petr Zvoníček on 18.12.16.
//  Copyright © 2016 The Funtasty. All rights reserved.
//

import UIKit

public protocol Coordinator {
    /// Triggers navigation to the corresponding controller
    func start()

    /// Stops corresponding controller and returns back to previous one
    func stop()

    /// Called when segue navigation form corresponding controller to different controller is about to start and should handle this navigation
    func navigate(from source: UIViewController, to destination: UIViewController, with identifier: String?, and sender: AnyObject?)
}

/// Navigate and stop methods are optional
public extension Coordinator {
    func navigate(from source: UIViewController, to destination: UIViewController, with identifier: String?, and sender: AnyObject?) {
    }

    func stop() {
    }
}

public protocol DefaultCoordinator: Coordinator {
    associatedtype ViewController: UIViewController
    weak var viewController: ViewController? { get set }

    var animated: Bool { get }
    weak var delegate: CoordinatorDelegate? { get }
}

public protocol PushCoordinator: DefaultCoordinator {
    var configuration: ((ViewController) -> Void)? { get }
    var navigationController: UINavigationController { get }
}

public protocol ModalCoordinator: DefaultCoordinator {
    var configuration: ((ViewController) -> Void)? { get }
    var navigationController: UINavigationController { get }
    weak var destinationNavigationController: UINavigationController? { get }
}

public protocol PushModalCoordinator: DefaultCoordinator {
    var configuration: ((ViewController) -> Void)? { get }
    var navigationController: UINavigationController? { get }
    weak var destinationNavigationController: UINavigationController? { get }
}

public extension DefaultCoordinator {
    // default implementation if not overriden
    var animated: Bool {
        return true
    }

    // default implementation of nil delegate, should be overriden when needed
    weak var delegate: CoordinatorDelegate? {
        return nil
    }
}

public extension PushCoordinator where ViewController: UIViewController, ViewController: Coordinated {
    func start() {
        guard let viewController = viewController else {
            return
        }

        configuration?(viewController)
        viewController.setCoordinator(self)
        navigationController.pushViewController(viewController, animated: animated)
    }

    func stop() {
        delegate?.willStop(in: self)
        navigationController.popViewController(animated: animated)
        delegate?.didStop(in: self)
    }
}

public extension ModalCoordinator where ViewController: UIViewController, ViewController: Coordinated {
    func start() {
        guard let viewController = viewController else {
            return
        }

        configuration?(viewController)
        viewController.setCoordinator(self)

        if let destinationNavigationController = destinationNavigationController {
            // wrapper navigation controller given, present it
            navigationController.present(destinationNavigationController, animated: animated, completion: nil)
        } else {
            // no wrapper navigation controller given, present actual controller
            navigationController.present(viewController, animated: animated, completion: nil)
        }
    }

    func stop() {
        delegate?.willStop(in: self)
        viewController?.dismiss(animated: true) {
            self.delegate?.didStop(in: self)
        }
    }
}

public extension PushModalCoordinator where ViewController: UIViewController, ViewController: Coordinated {
    func start() {
        guard let viewController = viewController else {
            return
        }

        configuration?(viewController)
        viewController.setCoordinator(self)

        // TODO: figure out better way to distinguish between Push and Modal behavior
        if let destinationNavigationController = destinationNavigationController {
            // wrapper navigation controller means ViewController should be presented modally
            navigationController?.present(destinationNavigationController, animated: animated, completion: nil)
        } else {
            // present controller normally (initializer for this case not implemented, just an exploration of a possible future case)
            navigationController?.pushViewController(viewController, animated: animated)
        }
    }

    func stop() {
        delegate?.willStop(in: self)

        // TODO: figure out better way to distinguish between Push and Modal behavior
        if destinationNavigationController != nil {
            viewController?.dismiss(animated: true) {
                self.delegate?.didStop(in: self)
            }
        } else {
            let _ = navigationController?.popViewController(animated: animated)
            delegate?.didStop(in: self)
        }
    }
}

public protocol CoordinatorDelegate: class {
    func willStop(in coordinator: Coordinator)
    func didStop(in coordinator: Coordinator)
}

/// Used typically on view controllers to refer to it's coordinator
public protocol Coordinated {
    func getCoordinator() -> Coordinator?
    func setCoordinator(_ coordinator: Coordinator)
}

public class CoordinatorSegue: UIStoryboardSegue {

    open var sender: AnyObject!

    override public func perform() {
        guard let source = self.source as? Coordinated else {
            return
        }

        source.getCoordinator()?.navigate(from: self.source, to: destination, with: identifier, and: sender)
    }
}
