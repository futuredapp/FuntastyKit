//
//  KeyboardScrollView.swift
//  FuntastyKit
//
//  Created by Patrik Potoček on 04/07/2019.
//  Copyright © 2019 The Funtasty. All rights reserved.
//

import UIKit

class KeyboardScrollView: UIScrollView {
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        let center: NotificationCenter = .default
        center.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillHideNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc
    private func keyboardWillChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        
        let insetHeight = (notification.name == UIResponder.keyboardWillHideNotification) ? 0.0 : height(for: userInfo) - inset
        self.contentInset.bottom = insetHeight
    }
    
    private var inset: CGFloat {
        if #available(iOS 11.0, *) {
            return superview?.safeAreaInsets.bottom ?? 0.0
        }
        return 0.0
    }
    
    private func height(for userInfo: [AnyHashable: Any]) -> CGFloat {
        return userInfo[UIResponder.keyboardFrameEndUserInfoKey]
            .flatMap { $0 as? NSValue }
            .map { $0.cgRectValue.height } ?? 0.0
    }
}
