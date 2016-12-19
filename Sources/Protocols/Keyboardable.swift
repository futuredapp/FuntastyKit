//
//  Keyboardable.swift
//  FuntastyKit
//
//  Created by Matěj Jirásek on 18/10/2016.
//  Copyright © 2016 FUNTASTY Digital s.r.o. All rights reserved.
//

import Foundation
import UIKit

protocol Keyboardable {
    func keyboardChanges(height: CGFloat)
}

extension Keyboardable {

    func useKeyboard() {
        let center = NotificationCenter.default
        center.addObserver(forName: .UIKeyboardWillChangeFrame, object: nil, queue: nil, using: keyboardWillChange)
        center.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil, using: keyboardWillHide)
    }

    func keyboardWillChange(notification: Notification) {
        guard let rect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        keyboardChanges(height: rect.size.height)
    }

    func keyboardWillHide(notification: Notification) {
        keyboardChanges(height: 0)
    }
}
