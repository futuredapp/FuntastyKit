import Foundation
import XCTest
import FuntastyKit

final class FuntastyKitTests: XCTestCase {

    func testArchitecture() {
        let model = Model()

        let viewController = UIViewController()
        UIApplication.shared.keyWindow?.rootViewController = viewController

        let coordinator = ExampleCoordinator(from: viewController, model: model)
        coordinator.start()
    }
}

#if os(Linux)
extension FuntastyKitTests {
    static var allTests: [(String, (FuntastyKitTests) -> () throws -> Void)] {
        return [
            ("testArchitecture", testArchitecture)
        ]
    }
}
#endif
