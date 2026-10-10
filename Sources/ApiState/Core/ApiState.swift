/// Represents the state of an asynchronous operation.
///
/// `ApiState` provides a consistent way to represent loading,
/// success, failure, refresh, and load-more states throughout an application.
public enum ApiState<Value> {
    /// The operation has not started yet.
    case initial

    /// The operation is currently in progress.
    case loading

    /// The operation completed successfully.
    case success(Value)

    /// The operation failed.
    case failure(any Failure, previousData: Value? = nil)

    /// Existing data is currently being refreshed.
    case refresh(Value)

    /// Existing data is currently being extended with another page.
    case loadMore(Value)
}

/// Makes `ApiState` safe to pass across Swift concurrency boundaries
/// when its associated value is also `Sendable`.
extension ApiState: Sendable where Value: Sendable {}
