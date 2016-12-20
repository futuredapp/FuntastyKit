//
//  StoryboardType.swift
//  FuntastyKit
//
//  Created by Patrik Potoček on 20.12.16.
//  Copyright © 2016 The Funtasty. All rights reserved.
//

import Foundation
import UIKit

public protocol StoryboardType {
    static var name: String { get }
}

public struct StoryboardReference<S: StoryboardType, T> {

    public let id: String

    public func instantiate() -> T {
        if let controller = UIStoryboard(name: S.name, bundle: nil).instantiateViewController(withIdentifier: id) as? T {
            return controller
        } else {
            fatalError("Instantiated controller with \(id) has different type than expected!")
        }
    }

}
