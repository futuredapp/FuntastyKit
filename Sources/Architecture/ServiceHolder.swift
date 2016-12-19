//
//  ServiceHelper.swift
//  FuntastyKit
//
//  Created by Martin Pinka on 02.11.16.
//  Copyright © 2016 The Funtasty. All rights reserved.
//

import Foundation

protocol Service {
    init()
}

class ServiceHolder {
    private var servicesDictionary: [String: Service] = [:]

    init(services: [Service.Type]? = nil) {
        services?.forEach {
            self.add($0)
        }
    }

    func add(_ type: Service.Type, with name: String? = nil) {
        let name = name ?? String(reflecting: type)
        servicesDictionary[name] = type.init()
    }

    func add<T>(_ protocolType: T.Type, for concreteType: Service.Type, with name: String? = nil) {
        self.add(protocolType, for: concreteType.init(), with: name)
    }

    func add<T>(_ type: T.Type, with name: String? = nil, constructor: () -> Service) {
        self.add(type, for: constructor(), with: name)
    }

    private func add<T>(_ protocolType: T.Type, for instance: Service, with name: String? = nil) {
        let name = name ?? String(reflecting: protocolType)
        servicesDictionary[name] = instance
    }

    func get<T>(by type: T.Type = T.self) -> T {
        return get(by: String(reflecting: type))
    }

    func get<T>(by name: String) -> T {
        guard let service = servicesDictionary[name] as? T else {
            fatalError("firstly you have to add the service")
        }

        return service
    }
}
