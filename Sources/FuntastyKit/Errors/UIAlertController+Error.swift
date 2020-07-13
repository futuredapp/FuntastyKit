import UIKit

public extension UIAlertController {
    convenience init(error: Error, preferredStyle: UIAlertController.Style = .alert) {
        self.init(title: UIAlertController.alertTitle(error: error),
                  message: UIAlertController.alertMessage(error: error),
                  preferredStyle: preferredStyle)
        if let error = error as? ResolvableError {
            error.actions.map { $0.alertAction() }.forEach(self.addAction)
            if !error.actions.isEmpty {
                return
            }
        }
        self.addAction(UIAlertAction(title: UIAlertController.okButtonText, style: .default))
    }

    private static func alertTitle(error: Error) -> String {
        switch error {
        case let error as LocalizedError:
            return error.errorDescription ?? defaultErrorTitle
        default:
            return defaultErrorTitle
        }
    }

    private static func alertMessage(error: Error) -> String {
        switch error {
        case let error as LocalizedError:
            return error.failureReason ?? error.localizedDescription
        default:
            return error.localizedDescription
        }
    }

    private static var defaultErrorTitle: String {
        NSLocalizedString("Error", comment: "Error")
    }

    private static var okButtonText: String {
        NSLocalizedString("OK", comment: "OK")
    }
}
