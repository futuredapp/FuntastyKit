import Foundation
import FuntastyKit
import XCTest

final class FuntastyKitTests: XCTestCase {

    func testArchitecture() {
        let model = Model()

        let viewController = UIViewController()
        UIApplication.shared.keyWindow?.rootViewController = viewController

        let coordinator = ExampleCoordinator(from: viewController, model: model)
        coordinator.start()
    }
}
