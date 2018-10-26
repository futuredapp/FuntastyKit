//
//  Nibable.swift
//  FuntastyKit
//
//  Created by Matěj Jirásek on 07/10/2016.
//  Copyright © 2016 FUNTASTY Digital s.r.o. All rights reserved.
//

import UIKit

public extension UIView {

    static var nibName: String {
        return String(describing: self)
    }

}

public protocol Nibable {
    static var nib: UINib { get }
}

public extension Nibable where Self: UIView {

    static var nib: UINib {
        return UINib(nibName: Self.nibName, bundle: nil)
    }

    init(owner: AnyObject? = nil) {
        let views = Self.nib.instantiate(withOwner: owner, options: [:])
        self = views.lazy.compactMap { $0 as? Self }.first ?? { () -> Self in
            fatalError("Nib for class \(Self.nibName) cound not be loaded!")
        }()
    }

}
