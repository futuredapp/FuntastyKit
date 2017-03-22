//
//  Keyboardable.swift
//  FuntastyKit
//
//  Created by Matěj Jirásek on 18/10/2016.
//  Copyright © 2016 FUNTASTY Digital s.r.o. All rights reserved.
//

import Foundation
import UIKit

public protocol Keyboardable: class {
    var keyboardObservers: [Any] { get set }
    func keyboardChanges(height: CGFloat)
}

public extension Keyboardable {

    func start() {
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

        keyboardObservers = [
            center.addObserver(forName: .UIKeyboardWillChangeFrame, object: nil, queue: nil, using: keyboardChangeFrameBlock),
            center.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil, using: keyboardWillHideBlock)
        ]

    }

    func stop() {
        let center = NotificationCenter.default
        keyboardObservers.forEach { center.removeObserver($0) }
    }
}
