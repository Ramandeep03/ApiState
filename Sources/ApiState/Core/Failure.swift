import Foundation

/// Describes a failure produced by an asynchronous operation.
///
/// Applications can define domain-specific failure types by conforming
/// to this protocol.
///
/// Example:
/// ```swift
/// struct NetworkFailure: Failure {
///     let message: String
///     let code: Int?
///     let stackTrace: [String]?
/// }
/// ```
public protocol Failure: Error, LocalizedError, Sendable {

    /// A human-readable description of the failure.
    var message: String { get }

    /// An optional application or server-specific error code.
    var code: Int? { get }

    /// An optional stack trace captured when the failure occurred.
    var stackTrace: [String]? { get }
}

public extension Failure {

    /// Provides the failure message through Swift's `LocalizedError` API.
    var errorDescription: String? {
        message
    }
}
