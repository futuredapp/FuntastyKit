import UIKit

/// Useful to ensure 1px size on retina displays
public class HairlineLayoutConstraint: NSLayoutConstraint {

    override public func awakeFromNib() {
        super.awakeFromNib()
        self.constant /= UIScreen.main.scale
    }
}
