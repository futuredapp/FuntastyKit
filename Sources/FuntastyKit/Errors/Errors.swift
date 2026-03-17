import Foundation

public protocol ResolvableError: LocalizedError {
    var actions: [ErrorAction] { get }
}

public struct ErrorAction: Sendable {
    public enum Style: Int, Sendable {
        case `default`
        case cancel
        case destructive
        case preferred
    }

    public typealias ErrorHandler = @MainActor @Sendable () -> Void

    public let title: String
    public var action: ErrorHandler?
    public var style: Style

    public init(title: String, style: Style = .default, action: ErrorHandler? = nil) {
        self.title = title
        self.style = style
        self.action = action
    }
}
