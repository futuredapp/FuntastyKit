//
//  KeyboardHeightConstraint.swift
//  FuntastyKit-iOS
//
//  Created by Matěj Jirásek on 07/02/2018.
//  Copyright © 2018 The Funtasty. All rights reserved.
//

import UIKit

final class KeyboardHeightConstraint: NSLayoutConstraint {

    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: .UIKeyboardWillChangeFrame, object: nil)
    }

    @objc
    private func keyboardWillChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }

        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey]
            .flatMap { $0 as? NSNumber }
            .flatMap { $0.doubleValue } ?? 0.0
        let options = userInfo[UIKeyboardAnimationCurveUserInfoKey]
            .flatMap { $0 as? NSNumber }
            .flatMap { $0.uintValue << 16 }
            .flatMap(UIViewAnimationOptions.init)
        let height = userInfo[UIKeyboardFrameEndUserInfoKey]
            .flatMap { $0 as? NSValue }
            .flatMap { $0.cgRectValue.height } ?? 0.0

        let insetHeight = height - inset

        superview?.layoutIfNeeded()
        UIView.animate(withDuration: duration, delay: 0, options: options ?? [], animations: {
            self.constant = insetHeight
            self.superview?.layoutIfNeeded()
        }, completion: nil)
    }

    private var superview: UIView? {
        return secondItem?.superview.flatMap { $0 }
    }

    private var inset: CGFloat {
        if #available(iOS 11.0, *) {
            return superview?.safeAreaInsets.bottom ?? 0.0
        }
        return 0.0
    }
}
