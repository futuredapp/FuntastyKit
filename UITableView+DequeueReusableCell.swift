//
//  UITableView+DequeueReusableCell.swift
//  FuntastyKit
//
//  Created by Matěj Jirásek on 09/02/2017.
//  Copyright © 2017 The Funtasty. All rights reserved.
//

import UIKit

public extension UITableView {
    public func dequeueReusableCell(convertible: CellConvertible) -> UITableViewCell {
        let cell = self.dequeueReusableCell(withType: convertible.cellType())
        if let cell = cell as? CellConfigurable {
            cell.configure(with: convertible)
        }
        return cell
    }

    public func registerCells(for models: [CellModel]) {
        var dictionary: [String: UITableViewCell.Type] = [:]
        models
            .map { $0.cellType() }
            .map { (String(describing: $0), $0) }
            .forEach { dictionary[$0] = $1 }
        dictionary.forEach { _, value in
            self.registerNib(for: value)
        }
    }
}
