//
//  APIAdapter.swift
//  FuntastyKit
//
//  Created by Matěj Jirásek on 08/02/2018.
//  Copyright © 2018 FUNTASTY Digital s.r.o. All rights reserved.
//

import Foundation

protocol APIAdapterDelegate: class {
    func apiAdapter(_ apiAdapter: APIAdapter, didUpdateRunningRequestCount runningrequestCount: UInt)
    func apiAdapter(_ apiAdapter: APIAdapter, requests: URLRequest, completion: @escaping (URLRequest) -> Void)
}

typealias APIAdapterErrorConstructor = (Data?, URLResponse?, Error?, JSONDecoder) -> Error?

protocol APIAdapter {
    var delegate: APIAdapterDelegate? { get set }

    func request<Endpoint: APIResponseEndpoint>(response endpoint: Endpoint, completion: @escaping (APIResult<Endpoint.Response>) -> Void)
    func request(data endpoint: APIEndpoint, completion: @escaping (APIResult<Data>) -> Void)
}

final class URLSessionAPIAdapter: APIAdapter {

    weak var delegate: APIAdapterDelegate?

    private let urlSession = URLSession.shared
    private let baseUrl: URL

    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder

    private let customErrorConstructor: APIAdapterErrorConstructor?

    private var runningRequestCount: UInt = 0 {
        didSet {
            delegate?.apiAdapter(self, didUpdateRunningRequestCount: runningRequestCount)
        }
    }

    init(baseUrl: URL, jsonEncoder: JSONEncoder = JSONEncoder(), jsonDecoder: JSONDecoder = JSONDecoder(), customErrorConstructor: APIAdapterErrorConstructor? = nil) {
        self.baseUrl = baseUrl
        self.jsonDecoder = jsonDecoder
        self.jsonEncoder = jsonEncoder
        self.customErrorConstructor = customErrorConstructor
    }

    func request<Endpoint: APIResponseEndpoint>(response endpoint: Endpoint, completion: @escaping (APIResult<Endpoint.Response>) -> Void) {
        request(model: endpoint, completion: completion)
    }

    func request<Model: Decodable>(model endpoint: APIEndpoint, completion: @escaping (APIResult<Model>) -> Void) {
        request(data: endpoint) { result in
            switch result {
            case .value(let data):
                do {
                    let model = try self.jsonDecoder.decode(Model.self, from: data)
                    completion(.value(model))
                } catch {
                    completion(.error(error))
                }
            case .error(let error):
                completion(.error(error))
            }
        }
    }

    func request(data endpoint: APIEndpoint, completion: @escaping (APIResult<Data>) -> Void) {
        request(path: endpoint.path, method: endpoint.method, data: endpoint.data, completion: completion)
    }

    func request(path: String, method: HTTPMethod, data: RequestData, completion: @escaping (APIResult<Data>) -> Void) {
        let url = baseUrl.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method.description

        switch data {
        case .jsonBody(let encodable):
            do {
                try request.setJSONBody(encodable: encodable, using: jsonEncoder)
            } catch {
                return completion(.error(error))
            }
        case .urlEncoded(let parameters):
            request.setURLEncoded(parameters: parameters)
        case .jsonParams(let parameters):
            request.setJSON(parameters: parameters, using: jsonEncoder)
        case let .json(body, parameters):
            request.setJSON(parameters: parameters, body: body, using: jsonEncoder)
        case let .multipart(parameters, data):
            request.setMultipart(parameters: parameters, data: data, filename: "image.jpg", mimeType: "image/jpeg")
        case .base64Upload(let parameters):
            request.appendBase64(parameters: parameters)
        }

        if let delegate = delegate {
            delegate.apiAdapter(self, requests: request) { request in
                self.execute(request: request, completion: completion)
            }
        }
        return execute(request: request, completion: completion)
    }

    private func execute(request: URLRequest, completion: @escaping (APIResult<Data>) -> Void) {
        runningRequestCount += 1
        dataTask(withRequest: request) { result in
            self.runningRequestCount -= 1
            completion(result)
        }
    }

    private func dataTask(withRequest urlRequest: URLRequest, completion: @escaping (APIResult<Data>) -> Void) {
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            switch (data, response, error) {
            case let (_, response as HTTPURLResponse, _) where response.statusCode == 204:
                completion(.value(Data()))
            case let (data?, response as HTTPURLResponse, nil):
                if let constructor = self.customErrorConstructor, let error = constructor(data, response, error, self.jsonDecoder) {
                    completion(.error(error))
                } else {
                    completion(.value(data))
                }
            case let (_, _, error?):
                completion(.error(error))
            default:
                break
            }
        }
        task.resume()
    }
}
