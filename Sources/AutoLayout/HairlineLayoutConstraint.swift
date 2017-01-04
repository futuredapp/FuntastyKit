//
//  HairlineLayoutConstraint.swift
//  FuntastyKit
//
//  Created by Petr Zvoníček on 18.12.16.
//  Copyright © 2016 The Funtasty. All rights reserved.
//

import UIKit

/// Useful to ensure 1px size on retina displays
public class HairlineLayoutConstraint: NSLayoutConstraint {

    override public func awakeFromNib() {
        super.awakeFromNib()
        self.constant = self.constant / UIScreen.main.scale
    }

}
