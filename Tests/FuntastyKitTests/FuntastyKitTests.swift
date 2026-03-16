import FuntastyKit
import Testing
import UIKit

@Suite
@MainActor
struct FuntastyKitTests {

    @Test
    func architecture() {
        let model = Model()

        let window = UIWindow()

        let viewController = UIViewController()
        window.rootViewController = viewController
        window.makeKeyAndVisible()

        let coordinator = ExampleCoordinator(from: viewController, model: model)
        coordinator.start()
    }
}
