//
//  UITableView+Extensions.swift
//  FuntastyKit
//
//  Created by Patrik Potoček on 20.12.16.
//  Copyright © 2016 The Funtasty. All rights reserved.
//

import Foundation
import UIKit

public extension UITableView {

    func registerNib<T: UITableViewCell>(for cellClass: T.Type) {
        let nib = UINib(nibName: cellClass.cellNibName, bundle: nil)
        register(nib, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }

    func registerCellClass<T: UITableViewCell>(_ type: T.Type) {
        register(type, forCellReuseIdentifier: type.reuseIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(withType type: T.Type) -> T {
        if let cell = dequeueReusableCell(withIdentifier: type.reuseIdentifier) as? T {
            return cell
        } else {
            fatalError("Cell with \(type.reuseIdentifier) reuse identifier does not exist.")
        }
    }
    
}

public extension UITableViewCell {

    static var cellNibName: String {
        return String(describing: self)
    }

    static var reuseIdentifier: String {
        return String(describing: self)
    }

}
