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
    weak var viewController: ViewController? { get }

    var animated: Bool { get }
    weak var delegate: CoordinatorDelegate? { get set }
}

public protocol PushCoordinator: DefaultCoordinator {
    func configure(viewController: ViewController)
    var navigationController: UINavigationController { get }
}

public protocol ModalCoordinator: DefaultCoordinator {
    func configure(viewController: ViewController)
    var sourceViewController: UIViewController { get }
    weak var destinationNavigationController: UINavigationController? { get }
}

public enum PresentationStyle {
    case push
    case modal
}

public protocol PushModalCoordinator: DefaultCoordinator {
    func configure(controller: ViewController)
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
        get {
            return nil
        }
        set {
        }
    }

    func stop() {
        delegate?.willStop(in: self)
        delegate?.didStop(in: self)
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

public extension PushModalCoordinator {
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

        configure(controller: viewController)

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
