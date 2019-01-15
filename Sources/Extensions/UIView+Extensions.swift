//
//  UIView+Extensions.swift
//  FuntastyKit
//
//  Created by Petr Zvoníček on 18.12.16.
//  Copyright © 2016 The Funtasty. All rights reserved.
//

import UIKit

@IBDesignable
extension UIView {

    // MARK: - Corner radius

    @IBInspectable open var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            #if !TARGET_INTERFACE_BUILDER
            layer.cornerRadius = newValue
            #endif
        }
    }

    // MARK: - Shadow

    @IBInspectable open var shadowColor: UIColor? {
        get {
            return layer.shadowColor.flatMap(UIColor.init)
        }
        set {
            #if !TARGET_INTERFACE_BUILDER
            layer.shadowColor = newValue?.cgColor
            #endif
        }
    }

    @IBInspectable open var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            #if !TARGET_INTERFACE_BUILDER
            layer.shadowOffset = newValue
            #endif
        }
    }

    @IBInspectable open var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            #if !TARGET_INTERFACE_BUILDER
            layer.shadowRadius = newValue
            #endif
        }
    }

    @IBInspectable open var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            #if !TARGET_INTERFACE_BUILDER
            layer.shadowOpacity = newValue
            #endif
        }
    }

    // MARK: - Border

    @IBInspectable open var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            #if !TARGET_INTERFACE_BUILDER
            layer.borderWidth = newValue
            #endif
        }
    }

    @IBInspectable open var borderColor: UIColor? {
        get {
            return layer.borderColor.flatMap(UIColor.init)
        }
        set {
            #if !TARGET_INTERFACE_BUILDER
            layer.borderColor = newValue?.cgColor
            #endif
        }
    }
}
