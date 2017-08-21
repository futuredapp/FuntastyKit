/**
 *  FuntastyKit
 *
 *  Copyright (c) 2016 Petr Zvonicek. Licensed under the MIT license, as follows:
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in all
 *  copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  SOFTWARE.
 */

import Foundation
import XCTest
import FuntastyKit

class FuntastyKitTests: XCTestCase {

    func testArchitecture() {

        final class ExampleViewController: UIViewController {
            private var viewModel: ExampleViewModel!

            func set(viewModel: ExampleViewModel) {
                self.viewModel = viewModel
            }
        }

        final class ExampleViewModel {
            private var coordinator: ExampleCoordinator

            init(coordinator: ExampleCoordinator) {
                self.coordinator = coordinator
            }
        }

        final class ExampleCoordinator: Coordinator {

            private weak var viewController: ExampleViewController?
            private var serviceHolder: ServiceHolder

            init(serviceHolder: ServiceHolder) {
                self.serviceHolder = serviceHolder
            }

            func start() {
                let viewController = ExampleViewController()
                let viewModel = ExampleViewModel(coordinator: self)
                viewController.set(viewModel: viewModel)

            }
            func stop() {}
        }

        let holder = ServiceHolder()
        let coordinator = ExampleCoordinator(serviceHolder: holder)
        coordinator.start()
        coordinator.stop()
    }
}

#if os(Linux)
extension FuntastyKitTests {
    static var allTests: [(String, (FuntastyKitTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample)
        ]
    }
}
#endif
