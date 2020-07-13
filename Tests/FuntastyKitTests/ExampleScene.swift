@testable import FuntastyKit
import UIKit

struct Model {
}

// MARK: - Controller

protocol ExampleViewControllerInput: AnyObject {
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
    private weak var viewController: ExampleViewControllerInput?
    private let coordinator: ExampleCoordinatorInput

    private let model: Model

    init(model: Model, coordinator: ExampleCoordinatorInput, viewController: ExampleViewControllerInput) {
        self.model = model
        self.coordinator = coordinator
        self.viewController = viewController
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
