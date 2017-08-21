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

final class ExampleService: Service {
}

// MARK: - Controller

protocol ExampleViewControllerInput: class {
    // TO-DO: Place your presenting methods here
}

final class ExampleViewController: UIViewController {
    var viewModel: ExampleViewModel!
}

extension ExampleViewController: ExampleViewControllerInput {
    // TO-DO: Place your presenting methods here
}

// MARK: - View model

final class ExampleViewModel {
    private weak var view: ExampleViewControllerInput?
    private let coordinator: ExampleCoordinatorInput

    private let model: Model

    private let service: ExampleService

    init(model: Model, coordinator: ExampleCoordinatorInput, view: ExampleViewControllerInput, service: ExampleService) {
        self.model = model
        self.service = service
        self.coordinator = coordinator
        self.view = view
    }
}

// MARK: - Coordinator

protocol ExampleCoordinatorInput: Coordinator {
    // TO-DO: Place your navigation methods here
}

final class ExampleCoordinator: ModalCoordinator {

    var sourceViewController: UIViewController
    var destinationNavigationController: UINavigationController?

    weak var viewController: ExampleViewController?
    private var serviceHolder: ServiceHolder

    private let model: Model

    init(from source: UIViewController, model: Model, serviceHolder: ServiceHolder) {
        self.sourceViewController = source
        self.destinationNavigationController = UINavigationController(rootViewController: ExampleViewController())
        self.viewController = destinationNavigationController?.topViewController as? ExampleViewController
        self.model = model
        self.serviceHolder = serviceHolder
    }

    func configure(controller: ExampleViewController) {
        let viewModel = ExampleViewModel(model: model, coordinator: self, view: controller, service: serviceHolder.get())
        controller.viewModel = viewModel
    }
}

extension ExampleCoordinator: ExampleCoordinatorInput {
    // TO-DO: Place your navigation methods here
}
