import Foundation

/// Utilities for converting throwing asynchronous operations into `ApiState`.
public extension ApiState {

    /// Executes an asynchronous operation and converts its result
    /// into an `ApiState`.
    ///
    /// A successful operation produces `.success`.
    /// A thrown error is converted into `.failure` using `onError`.
    ///
    /// A stack trace is captured and supplied to the error mapper.
    ///
    /// Example:
    /// ```swift
    /// let state = await ApiState<User>.guardAsync(
    ///     {
    ///         try await repository.fetchUser()
    ///     },
    ///     onError: { error, stackTrace in
    ///         ServerFailure(
    ///             error.localizedDescription,
    ///             stackTrace: stackTrace
    ///         )
    ///     }
    /// )
    /// ```
    ///
    /// - Parameters:
    ///   - operation: The asynchronous throwing operation to execute.
    ///   - onError: Converts an `Error` and stack trace into a `Failure`.
    /// - Returns: `.success` when the operation succeeds or `.failure`
    ///   when the operation throws.
    static func guardAsync(
        _ operation: () async throws -> Value,
        onError: (
            Error,
            [String]
        ) -> any Failure
    ) async -> ApiState<Value> {
        do {
            return .success(
                try await operation()
            )
        } catch {
            return .failure(
                onError(
                    error,
                    Thread.callStackSymbols
                )
            )
        }
    }
}
