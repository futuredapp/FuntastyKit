//
//  StoryboardType.swift
//  FuntastyKit
//
//  Created by Aleš Kocur on 21.05.16.
//  Copyright © 2016 The Funtasty. All rights reserved.
//

import Foundation
import UIKit

public protocol StoryboardType {
    static var name: String { get }
}

public struct StoryboardReference<S: StoryboardType, T> {

    public let id: String

    public init(id: String) {
        self.id = id
    }

    public func instantiate() -> T {
        if let controller = UIStoryboard(name: S.name, bundle: nil).instantiateViewController(withIdentifier: id) as? T {
            return controller
        } else {
            fatalError("Instantiated controller with \(id) has different type than expected!")
        }
    }

}
