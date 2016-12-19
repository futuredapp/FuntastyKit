//
//  HairlineLayoutConstraint.swift
//  FuntastyKit
//
//  Created by Petr Zvoníček on 18.12.16.
//  Copyright © 2016 The Funtasty. All rights reserved.
//

import UIKit

/// Useful to ensure 1px size on retina displays
class HairlineLayoutConstraint: NSLayoutConstraint {

    override func awakeFromNib() {
        self.constant = self.constant / UIScreen.main.scale
    }

}
