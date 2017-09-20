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
    var sourceViewController: UIViewController { get }
    weak var destinationNavigationController: UINavigationController? { get }
}

public enum PresentationStyle {
    case push
    case modal
}

public protocol PushModalCoordinator: DefaultCoordinator {
    var configuration: ((ViewController) -> Void)? { get }
    var navigationController: UINavigationController? { get }
    var presentationStyle: PresentationStyle { get }
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

public extension PushCoordinator where ViewController: Coordinated {
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

public extension ModalCoordinator where ViewController: Coordinated {
    func start() {
        guard let viewController = viewController else {
            return
        }

        configuration?(viewController)
        viewController.setCoordinator(self)

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

public extension PushModalCoordinator where ViewController: Coordinated {
    // By default, to distinguish between modal and push a presence of destinationNavigationController is checked
    // as this is a good heuristics (it's usually not desired to push another navigation controller). This behaviour
    // can be redefined by redeclaring this property on any concrete PushModalCoordinator.
    var presentationStyle: PresentationStyle {
        return self.destinationNavigationController != nil ? .modal : .push
    }

    func start() {
        guard let viewController = viewController else {
            return
        }

        configuration?(viewController)
        viewController.setCoordinator(self)

        switch presentationStyle {
        case .modal where destinationNavigationController != nil:
            navigationController?.present(destinationNavigationController!, animated: animated, completion: nil)
        case .push:
            navigationController?.pushViewController(viewController, animated: animated)
        default:
            break
        }
    }

    func stop() {
        delegate?.willStop(in: self)

        switch presentationStyle {
        case .modal:
            viewController?.dismiss(animated: animated) {
                self.delegate?.didStop(in: self)
            }
        case .push:
            _ = navigationController?.popViewController(animated: animated)
            delegate?.didStop(in: self)
        }
    }
}

public protocol CoordinatorDelegate: class {
    func willStop(in coordinator: Coordinator)
    func didStop(in coordinator: Coordinator)
}

/// Used typically on view controllers to refer to it's coordinator
public protocol Coordinated: class {
    associatedtype C: Coordinator
    var coordinator: C! { get set }
    func getCoordinator() -> Coordinator?
    func setCoordinator(_ coordinator: Coordinator)
}

public extension Coordinated {
    func getCoordinator() -> Coordinator? {
        return coordinator
    }

    func setCoordinator(_ coordinator: Coordinator) {
        self.coordinator = coordinator as! C
    }
}
