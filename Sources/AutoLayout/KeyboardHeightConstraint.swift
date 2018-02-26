//
//  KeyboardHeightConstraint.swift
//  FuntastyKit-iOS
//
//  Created by Matěj Jirásek on 07/02/2018.
//  Copyright © 2018 The Funtasty. All rights reserved.
//

import UIKit

public final class KeyboardHeightConstraint: NSLayoutConstraint {

    override public func awakeFromNib() {
        super.awakeFromNib()

        let center: NotificationCenter = .default
        center.addObserver(self, selector: #selector(keyboardWillChange), name: .UIKeyboardWillHide, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillChange), name: .UIKeyboardWillShow, object: nil)
    }

    private var superview: UIView? {
        return (secondItem as? UIView)?.superview
    }

    @objc
    private func keyboardWillChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }

        let insetHeight = (notification.name == .UIKeyboardWillHide) ? 0.0 : height(for: userInfo) - inset

        superview?.layoutIfNeeded()
        UIView.animate(withDuration: duration(from: userInfo), delay: 0, options: options(from: userInfo), animations: {
            self.constant = insetHeight
            self.superview?.layoutIfNeeded()
        }, completion: nil)
    }

    private var inset: CGFloat {
        if #available(iOS 11.0, *) {
            return superview?.safeAreaInsets.bottom ?? 0.0
        }
        return 0.0
    }

    private func height(for userInfo: [AnyHashable: Any]) -> CGFloat {
        return userInfo[UIKeyboardFrameEndUserInfoKey]
            .flatMap { $0 as? NSValue }
            .map { $0.cgRectValue.height } ?? 0.0
    }

    private func duration(from userInfo: [AnyHashable: Any]) -> Double {
        return userInfo[UIKeyboardAnimationDurationUserInfoKey]
            .flatMap { $0 as? NSNumber }
            .map { $0.doubleValue } ?? 0.0
    }

    private func options(from userInfo: [AnyHashable: Any]) -> UIViewAnimationOptions {
        return userInfo[UIKeyboardAnimationCurveUserInfoKey]
            .flatMap { $0 as? NSNumber }
            .map { $0.uintValue << 16 }
            .map(UIViewAnimationOptions.init) ?? UIViewAnimationOptions()
    }
}
