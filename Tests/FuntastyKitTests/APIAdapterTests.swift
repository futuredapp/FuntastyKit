//
//  APIAdapterTests.swift
//  FuntastyKit
//
//  Created by Matěj Kašpar Jirásek on 03/09/2018.
//  Copyright © 2018 The Funtasty. All rights reserved.
//

// swiftlint:disable nesting

import XCTest
@testable import FuntastyKit

final class APIAdapterTests: XCTestCase {

    private func apiAdapter() -> APIAdapter {
        return URLSessionAPIAdapter(baseUrl: URL(string: "http://httpbin.org/")!)
    }

    private let timeout: TimeInterval = 30.0

    func testGet() {
        struct Endpoint: APIEndpoint {
            let path = "get"
        }

        let adapter = apiAdapter()
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

        let adapter = apiAdapter()
        let expectation = self.expectation(description: "Result")
        adapter.request(data: Endpoint()) { result in
            expectation.fulfill()
            if case .value = result {
                XCTFail("404 endpoint must fail")
            }
        }
        wait(for: [expectation], timeout: timeout)
    }

    func testJSONResponse() {
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

        let adapter = apiAdapter()
        let expectation = self.expectation(description: "Result")
        adapter.request(response: Endpoint()) { result in
            expectation.fulfill()
            if case let .error(error) = result {
                XCTFail(error.localizedDescription)
            }
        }
        wait(for: [expectation], timeout: timeout)
    }

    func testJSONRequestResponse() {
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
        let adapter = apiAdapter()
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
}
