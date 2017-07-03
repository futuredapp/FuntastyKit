//
//  Keyboardable.swift
//  FuntastyKit
//
//  Created by Matěj Jirásek on 18/10/2016.
//  Copyright © 2016 FUNTASTY Digital s.r.o. All rights reserved.
//

import Foundation
import UIKit

public class KeyboardableToken {
    let center: NotificationCenter
    let changeFrameToken: NSObjectProtocol
    let hideToken: NSObjectProtocol

    init(changeFrameToken: NSObjectProtocol, hideToken: NSObjectProtocol, center: NotificationCenter) {
        self.changeFrameToken = changeFrameToken
        self.hideToken = hideToken
        self.center = center
    }

    deinit {
        center.removeObserver(changeFrameToken)
        center.removeObserver(hideToken)
    }
}

public protocol Keyboardable: class {
    func keyboardChanges(height: CGFloat)
}

public extension Keyboardable {

    func useKeyboard() -> KeyboardableToken {
        let center = NotificationCenter.default

        let keyboardChangeFrameBlock: (Notification) -> Void = { [weak self] notification in
            guard let rect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
            }
            self?.keyboardChanges(height: rect.size.height)
        }

        let keyboardWillHideBlock: (Notification) -> Void = { [weak self] _ in
            self?.keyboardChanges(height: 0)
        }

        let changeFrameToken = center.addObserver(forName: .UIKeyboardWillChangeFrame, object: nil, queue: nil, using: keyboardChangeFrameBlock)
        let hideToken = center.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil, using: keyboardWillHideBlock)
        return KeyboardableToken(changeFrameToken: changeFrameToken, hideToken: hideToken, center: center)
    }
}
