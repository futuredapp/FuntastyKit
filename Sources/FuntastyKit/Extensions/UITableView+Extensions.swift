import Foundation
import UIKit

public extension UITableView {

    func registerNib<T: UITableViewCell>(for cellClass: T.Type) {
        let nib = UINib(nibName: cellClass.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: cellClass.nibName)
    }

    func registerCellClass<T: UITableViewCell>(_ type: T.Type) {
        register(type, forCellReuseIdentifier: type.nibName)
    }

    func dequeueReusableCell<T: UITableViewCell>(withType type: T.Type) -> T {
        if let cell = dequeueReusableCell(withIdentifier: type.nibName) as? T {
            return cell
        } else {
            fatalError("Cell with \(type.nibName) reuse identifier does not exist.")
        }
    }

}
