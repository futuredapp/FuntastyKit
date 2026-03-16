import UIKit

extension UIView {
    public static var nibName: String {
        String(describing: self)
    }
}

extension UITableView {
    public func registerNib<T: UITableViewCell>(for cellClass: T.Type) {
        let nib = UINib(nibName: cellClass.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: cellClass.nibName)
    }

    public func registerCellClass<T: UITableViewCell>(_ type: T.Type) {
        register(type, forCellReuseIdentifier: type.nibName)
    }

    public func dequeueReusableCell<T: UITableViewCell>(withType type: T.Type) -> T {
        if let cell = dequeueReusableCell(withIdentifier: type.nibName) as? T {
            return cell
        } else {
            fatalError("Cell with \(type.nibName) reuse identifier does not exist.")
        }
    }
}
