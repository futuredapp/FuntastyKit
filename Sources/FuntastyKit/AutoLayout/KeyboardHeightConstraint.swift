import UIKit

public final class KeyboardHeightConstraint: NSLayoutConstraint {

    override public func awakeFromNib() {
        super.awakeFromNib()

        let center: NotificationCenter = .default
        center.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillHideNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    private var superview: UIView? {
        (secondItem as? UIView)?.superview
    }

    @objc
    private func keyboardWillChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }

        let insetHeight = (notification.name == UIResponder.keyboardWillHideNotification) ? 0.0 : height(for: userInfo) - inset

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
        userInfo[UIResponder.keyboardFrameEndUserInfoKey]
            .flatMap { $0 as? NSValue }
            .map { $0.cgRectValue.height } ?? 0.0
    }

    private func duration(from userInfo: [AnyHashable: Any]) -> Double {
        userInfo[UIResponder.keyboardAnimationDurationUserInfoKey]
            .flatMap { $0 as? NSNumber }
            .map { $0.doubleValue } ?? 0.0
    }

    private func options(from userInfo: [AnyHashable: Any]) -> UIView.AnimationOptions {
        userInfo[UIResponder.keyboardAnimationCurveUserInfoKey]
            .flatMap { $0 as? NSNumber }
            .map { $0.uintValue << 16 }
            .map(UIView.AnimationOptions.init) ?? UIView.AnimationOptions()
    }
}
