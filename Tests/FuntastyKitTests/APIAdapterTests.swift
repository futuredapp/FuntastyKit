//
//  APIAdapterTests.swift
//  FuntastyKit
//
//  Created by Matěj Kašpar Jirásek on 03/09/2018.
//  Copyright © 2018 The Funtasty. All rights reserved.
//

// swiftlint:disable nesting

import XCTest
import FuntastyKit

final class APIAdapterTests: XCTestCase {

    private func apiAdapter() -> APIAdapter {
        return URLSessionAPIAdapter(baseUrl: URL(string: "http://httpbin.org/")!)
    }

    private let timeout: TimeInterval = 30.0

    func testGet() {
        struct Endpoint: APIEndpoint {
            let path = "get"
        }

        let delegate = MockupAPIAdapterDelegate()
        var adapter = apiAdapter()
        adapter.delegate = delegate
        let expectation = self.expectation(description: "Result")
        adapter.request(data: Endpoint()) { result in
            expectation.fulfill()
            if case let .error(error) = result {
                XCTFail(error.localizedDescription)
            }
        }
        wait(for: [expectation], timeout: timeout)
    }

    func testGetFail() {
        struct Endpoint: APIEndpoint {
            let path = "status/404"
        }

        let delegate = MockupAPIAdapterDelegate()
        var adapter = apiAdapter()
        adapter.delegate = delegate
        let expectation = self.expectation(description: "Result")
        adapter.request(data: Endpoint()) { result in
            expectation.fulfill()
            if case .value = result {
                XCTFail("404 endpoint must fail")
            }
        }
        wait(for: [expectation], timeout: timeout)
    }

    func testInvalidDomain() {
        struct Endpoint: APIEndpoint {
            let path = "some-failing-path"
        }

        let delegate = MockupAPIAdapterDelegate()
        var adapter: APIAdapter = URLSessionAPIAdapter(baseUrl: URL(string: "https://www.tato-stranka-urcite-neexistuje.cz/")!)
        adapter.delegate = delegate
        let expectation = self.expectation(description: "Result")
        adapter.request(data: Endpoint()) { result in
            expectation.fulfill()
            if case .value = result {
                XCTFail("Non-existing domain must fail")
            }
        }
        wait(for: [expectation], timeout: timeout)
    }

    func testEmptyResult() {
        struct Endpoint: APIEndpoint {
            let path = "status/204"
        }

        let delegate = MockupAPIAdapterDelegate()
        var adapter = apiAdapter()
        adapter.delegate = delegate
        let expectation = self.expectation(description: "Result")
        adapter.request(data: Endpoint()) { result in
            expectation.fulfill()
            if case let .error(error) = result {
                XCTFail(error.localizedDescription)
            }
        }
        wait(for: [expectation], timeout: timeout)
    }

    func testCustomError() {
        struct Endpoint: APIEndpoint {
            let path = "get"
        }

        struct CustomError: Error {
            private init() {}

            init?(data: Data?, response: URLResponse?, error: Error?, decoder: JSONDecoder) {
                self = CustomError()
            }
        }

        let delegate = MockupAPIAdapterDelegate()
        var adapter: APIAdapter = URLSessionAPIAdapter(baseUrl: URL(string: "http://httpbin.org/")!, customErrorConstructor: CustomError.init)
        adapter.delegate = delegate
        let expectation = self.expectation(description: "Result")
        adapter.request(data: Endpoint()) { result in
            expectation.fulfill()
            if case let .error(error) = result {
                XCTAssertTrue(error is CustomError)
            } else {
                XCTFail("Custom error must be returned")
            }
        }
        wait(for: [expectation], timeout: timeout)
    }

    func testValidJSONResponse() {
        struct TopLevel: Codable {
            let slideshow: Slideshow
        }

        struct Slideshow: Codable {
            let author, date: String
            let slides: [Slide]
            let title: String
        }

        struct Slide: Codable {
            let title, type: String
            let items: [String]?
        }

        struct Endpoint: APIResponseEndpoint {
            typealias Response = TopLevel

            let path = "json"
        }

        let delegate = MockupAPIAdapterDelegate()
        var adapter = apiAdapter()
        adapter.delegate = delegate
        let expectation = self.expectation(description: "Result")
        adapter.request(response: Endpoint()) { result in
            expectation.fulfill()
            if case let .error(error) = result {
                XCTFail(error.localizedDescription)
            }
        }
        wait(for: [expectation], timeout: timeout)
    }

    func testValidJSONRequestResponse() {
        struct User: Codable, Equatable {
            let uuid: UUID
            let name: String
            let age: UInt
        }

        struct TopLevel: Decodable {
            let json: User
        }

        struct Endpoint: APIRequestResponseEndpoint {
            typealias Request = User
            typealias Response = TopLevel

            let data: RequestData
            let method: HTTPMethod = .post
            let path = "anything"
        }

        let user = User(uuid: UUID(), name: "Some Name", age: .random(in: 0...120))
        let endpoint = Endpoint(request: user)
        let delegate = MockupAPIAdapterDelegate()
        var adapter = apiAdapter()
        adapter.delegate = delegate
        let expectation = self.expectation(description: "Result")
        adapter.request(response: endpoint) { result in
            expectation.fulfill()
            switch result {
            case .value(let response):
                XCTAssertEqual(user, response.json)
            case .error(let error):
                XCTFail(error.localizedDescription)
            }
        }
        wait(for: [expectation], timeout: timeout)
    }

    func testInvalidJSONRequestResponse() {
        struct User: Codable, Equatable {
            let uuid: UUID
            let name: String
            let age: UInt
        }

        struct Endpoint: APIRequestResponseEndpoint {
            typealias Request = User
            typealias Response = User

            let data: RequestData
            let method: HTTPMethod = .post
            let path = "anything"
        }

        let user = User(uuid: UUID(), name: "Some Name", age: .random(in: 0...120))
        let endpoint = Endpoint(request: user)
        let delegate = MockupAPIAdapterDelegate()
        var adapter = apiAdapter()
        adapter.delegate = delegate
        let expectation = self.expectation(description: "Result")
        adapter.request(response: endpoint) { result in
            expectation.fulfill()
            if case .value = result {
                XCTFail("Received valid value, decoding must fail")
            }
        }
        wait(for: [expectation], timeout: timeout)
    }

    func testAuthorization() {
        struct Endpoint: APIEndpoint {
            let path = "bearer"
            let authorized = true
        }

        let delegate = MockupAPIAdapterDelegate()
        var adapter = apiAdapter()
        adapter.delegate = delegate

        let expectation = self.expectation(description: "Result")
        adapter.request(data: Endpoint()) { result in
            expectation.fulfill()
            if case let .error(error) = result {
                XCTFail(error.localizedDescription)
            }
        }
        wait(for: [expectation], timeout: timeout)
    }
}
