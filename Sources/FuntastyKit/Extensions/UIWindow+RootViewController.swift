import UIKit

/**
 *  UIWindow extension for setting the rootViewController on a UIWindow instance in a safe and animatable way.
 */
extension UIWindow {

    /**
     Set the rootViewController on this UIWindow instance.

     - parameter viewController: The view controller to set
     - parameter animated:       Whether or not to animate the transition, animation is a cross-fade
     */
    @nonobjc
    public func setRootViewController(
        _ viewController: UIViewController,
        animated: Bool,
        duration: TimeInterval = 0.3,
        options: UIView.AnimationOptions = .transitionCrossDissolve
    ) async {
        rootViewController = viewController
        if animated {
            await withCheckedContinuation { continuation in
                UIView.transition(with: self, duration: duration, options: options, animations: nil) { _ in
                    continuation.resume()
                }
            }
        }
    }
}
