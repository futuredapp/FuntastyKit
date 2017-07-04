//
//  HomeCellViewModel.swift
//  Zdravel
//
//  Created by Matěj Jirásek on 19/01/2017.
//  Copyright © 2017 The Funtasty s.r.o. All rights reserved.
//

import UIKit

public protocol CellModel: CellConvertible {
    var cellHeight: CGFloat { get }
    var highlighting: Bool { get }
}

public extension CellModel {
    var highlighting: Bool {
        return true
    }

    var cellHeight: CGFloat {
        return 44
    }
}
