//
//  CellDescriptor.swift
//  Zdravel
//
//  Created by Matěj Jirásek on 23/01/2017.
//  Copyright © 2017 The Funtasty s.r.o. All rights reserved.
//

import UIKit

public protocol CellConvertible {
    func cellType() -> UITableViewCell.Type
}

public protocol CellConfigurable {
    func configure(with model: CellConvertible)
}
