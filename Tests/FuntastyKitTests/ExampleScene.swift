@testable import FuntastyKit
import UIKit

struct Model {
}

// MARK: - Controller

@MainActor
protocol ExampleViewControllerInput: AnyObject {
    // TO-DO: Place your presenting methods here
}

@MainActor
final class ExampleViewController: UIViewController {

    var viewModel: ExampleViewModel?
}

extension ExampleViewController: ExampleViewControllerInput {
    // TO-DO: Place your presenting methods here
}

// MARK: - View model

@MainActor
final class ExampleViewModel {
    private weak var viewController: (any ExampleViewControllerInput)?
    private let coordinator: any ExampleCoordinatorInput

    private let model: Model

    init(model: Model, coordinator: any ExampleCoordinatorInput, viewController: any ExampleViewControllerInput) {
        self.model = model
        self.coordinator = coordinator
        self.viewController = viewController
    }
}

// MARK: - Coordinator

@MainActor
protocol ExampleCoordinatorInput: Coordinator {
    // TO-DO: Place your navigation methods here
}

@MainActor
final class ExampleCoordinator: ModalCoordinator {

    var sourceViewController: UIViewController
    var destinationNavigationController: UINavigationController?

    weak var viewController: ExampleViewController?

    private let model: Model

    init(from source: UIViewController, model: Model) {
        let controller = ExampleViewController()
        self.destinationNavigationController = UINavigationController(rootViewController: controller)
        self.viewController = controller
        self.sourceViewController = source
        self.model = model
    }

    func configure(viewController: ExampleViewController) {
        let viewModel = ExampleViewModel(model: model, coordinator: self, viewController: viewController)
        viewController.viewModel = viewModel
    }
}

extension ExampleCoordinator: ExampleCoordinatorInput {
    // TO-DO: Place your navigation methods here
}
