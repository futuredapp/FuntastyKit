//
//  ServiceHelper.swift
//  FuntastyKit
//
//  Created by Martin Pinka on 02.11.16.
//  Copyright © 2016 The Funtasty. All rights reserved.
//

import Foundation

public protocol Service: class {}
public protocol InitializableService: Service {
    init()
}

public enum ServiceHolderError: Error {
    /// Service does not implement given protocol
    case serviceProtocolNotImplemented(protocol: Service.Type, service: Service.Type)
}

public enum ServiceScope {
    /// Instance is only created once within ServiceHolder
    case singleton
    /// On each get new instance is created using closure provided when added
    case transient
}

public class ServiceHolder {
    private enum ServiceRecord {
        case singleton(instance: Service)
        case transient(builder: () -> Service)
    }

    private var servicesDictionary: [String: ServiceRecord] = [:]

    public init() {}

    /// Add IntializableService constructed through empty constructor using the name of the protocol
    public func add<T: Service, S: InitializableService>(_ protocolType: T.Type,
                                                         with scope: ServiceScope = .singleton,
                                                         using serviceType: S.Type) throws {
        try add(protocolType, with: scope, using: serviceType.init)
    }

    /// Add instance as a singleton using the name of the protocol
    public func add<T: Service, S: Service>(_ protocolType: T.Type,
                                            using instance: S) throws {
        try add(protocolType, with: .singleton) {
            return instance
        }
    }

    /// Add Service constructed through closure provided using the name of the protocol
    func add<T: Service, S: Service>(_ protocolType: T.Type,
                                     with scope: ServiceScope = .singleton,
                                     using builder: @escaping () -> S) throws {
        guard S.self is T.Type else {
            throw ServiceHolderError.serviceProtocolNotImplemented(protocol: T.self, service: S.self)
        }
        let name = String(reflecting: protocolType)
        add(name, with: scope, using: builder)
    }

    /// Add Service constructed through closure provided using the given name
    func add(_ name: String,
             with scope: ServiceScope = .singleton,
             using builder: @escaping () -> Service) {
        switch scope {
        case .singleton:
            servicesDictionary[name] = .singleton(instance: builder())
        case .transient:
            servicesDictionary[name] = .transient(builder: builder)
        }
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
