import UIKit

/**
 *  UIWindow extension for setting the rootViewController on a UIWindow instance in a safe and animatable way.
 */
extension UIWindow {

    /**
     Set the rootViewController on this UIWindow instance.

     - parameter viewController: The view controller to set
     - parameter animated:       Whether or not to animate the transition, animation is a cross-fade
     - returns: `true` if the animation finished, `false` if it was interrupted. Always `true` when not animated.
     */
    @nonobjc
    @discardableResult
    public func setRootViewController(
        _ viewController: UIViewController,
        animated: Bool,
        duration: TimeInterval = 0.3,
        options: UIView.AnimationOptions = .transitionCrossDissolve
    ) async -> Bool {
        rootViewController = viewController
        guard animated else {
            return true
        }
        return await withCheckedContinuation { continuation in
            UIView.transition(with: self, duration: duration, options: options, animations: nil) { finished in
                continuation.resume(returning: finished)
            }
        }
    }
}
