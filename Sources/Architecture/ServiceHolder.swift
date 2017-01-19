//
//  ServiceHelper.swift
//  FuntastyKit
//
//  Created by Martin Pinka on 02.11.16.
//  Copyright © 2016 The Funtasty. All rights reserved.
//

import Foundation

public protocol Service {}
public protocol InitializableService: Service {
    init()
}

public class ServiceHolder {
    private var servicesDictionary: [String: Service] = [:]

    public init(services: [InitializableService.Type]? = nil) {
        services?.forEach {
            self.add($0)
        }
    }

    public func add(_ type: InitializableService.Type, with name: String? = nil) {
        let name = name ?? String(reflecting: type)
        servicesDictionary[name] = type.init()
    }

    public func add<T>(_ protocolType: T.Type, for concreteType: InitializableService.Type, with name: String? = nil) {
        self.add(protocolType, for: concreteType.init(), with: name)
    }

    public func add<T>(_ type: T.Type, with name: String? = nil, constructor: () -> Service) {
        self.add(type, for: constructor(), with: name)
    }

    private func add<T>(_ protocolType: T.Type, for instance: Service, with name: String? = nil) {
        let name = name ?? String(reflecting: protocolType)
        servicesDictionary[name] = instance
    }

    public func get<T>(by type: T.Type = T.self) -> T {
        return get(by: String(reflecting: type))
    }

    public func get<T>(by name: String) -> T {
        guard let service = servicesDictionary[name] as? T else {
            fatalError("firstly you have to add the service")
        }

        return service
    }
}
