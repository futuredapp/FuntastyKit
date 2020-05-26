import UIKit

/**
 *  UIWindow extension for setting the rootViewController on a UIWindow instance in a safe and animatable way.
 */
public extension UIWindow {

    /**
     Set the rootViewController on this UIWindow instance.

     - parameter viewController: The view controller to set
     - parameter animated:       Whether or not to animate the transition, animation is a cross-fade
     - parameter completion:     Completion block to be invoked after the transition finishes
     */
    @nonobjc
    func setRootViewController(_ viewController: UIViewController, animated: Bool, duration: TimeInterval = 0.3, options: UIView.AnimationOptions = .transitionCrossDissolve, completion: ((Bool) -> Void)? = nil) {
        rootViewController = viewController
        if animated {
            UIView.transition(with: self, duration: duration, options: options, animations: nil, completion: completion)
        }
    }
}
