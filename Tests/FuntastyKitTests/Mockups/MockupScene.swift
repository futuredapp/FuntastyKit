//
//  ExampleScene.swift
//  FuntastyKit-iOS
//
//  Created by Matěj Jirásek on 21/08/2017.
//  Copyright © 2017 The Funtasty. All rights reserved.
//

import UIKit
@testable import FuntastyKit

struct Model {
}

final class MockupService: Service {
}

// MARK: - Controller

protocol MockupViewControllerInput: class {
    // TO-DO: Place your presenting methods here
}

final class MockupViewController: UIViewController {
    var viewModel: MockupViewModel!
}

extension MockupViewController: MockupViewControllerInput {
    // TO-DO: Place your presenting methods here
}

// MARK: - View model

final class MockupViewModel {
    private weak var viewController: MockupViewControllerInput?
    private let coordinator: MockupCoordinatorInput

    private let model: Model

    private let service: MockupService

    init(model: Model, coordinator: MockupCoordinatorInput, viewController: MockupViewControllerInput, service: MockupService) {
        self.model = model
        self.service = service
        self.coordinator = coordinator
        self.viewController = viewController
    }
}

// MARK: - Coordinator

protocol MockupCoordinatorInput: Coordinator {
    // TO-DO: Place your navigation methods here
}

final class MockupCoordinator: ModalCoordinator {

    var sourceViewController: UIViewController
    var destinationNavigationController: UINavigationController?

    weak var viewController: MockupViewController?
    private var serviceHolder: ServiceHolder

    private let model: Model

    init(from source: UIViewController, model: Model, serviceHolder: ServiceHolder) {
        let controller = MockupViewController()
        self.destinationNavigationController = UINavigationController(rootViewController: controller)
        self.viewController = controller
        self.sourceViewController = source
        self.model = model
        self.serviceHolder = serviceHolder
    }

    func configure(viewController: MockupViewController) {
        let viewModel = MockupViewModel(model: model, coordinator: self, viewController: viewController, service: serviceHolder.get())
        viewController.viewModel = viewModel
    }
}

extension MockupCoordinator: MockupCoordinatorInput {
    // TO-DO: Place your navigation methods here
}
