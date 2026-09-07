/// Pattern-matching utilities for handling `ApiState` values.
public extension ApiState {

    /// Handles every possible state and returns a value.
    ///
    /// Initial and loading states share the `initialOrLoading` handler.
    ///
    /// If no `refresh` handler is supplied, refresh values are passed
    /// to the `success` handler.
    ///
    /// - Parameters:
    ///   - initialOrLoading: Called for `.initial` and `.loading`.
    ///   - success: Called when the operation succeeds.
    ///   - failure: Called when the operation fails.
    ///   - refresh: Optionally called while existing data is refreshing.
    /// - Returns: The result produced by the matching handler.
    func when<Result>(
        initialOrLoading: () -> Result,
        success: (Value) -> Result,
        failure: (any Failure) -> Result,
        refresh: ((Value) -> Result)? = nil
    ) -> Result {
        switch self {
        case .initial, .loading:
            return initialOrLoading()

        case .success(let value):
            return success(value)

        case .failure(let apiFailure):
            return failure(apiFailure)

        case .refresh(let value):
            return refresh?(value) ?? success(value)
        }
    }

    /// Executes a handler for the current state when one is provided.
    ///
    /// Unlike `when`, every handler is optional.
    ///
    /// - Returns: The handler result, or `nil` when no matching
    ///   handler was provided.
    func whenOrNull<Result>(
        initialOrLoading: (() -> Result)? = nil,
        success: ((Value) -> Result)? = nil,
        failure: ((any Failure) -> Result)? = nil,
        refresh: ((Value) -> Result)? = nil
    ) -> Result? {
        switch self {
        case .initial, .loading:
            return initialOrLoading?()

        case .success(let value):
            return success?(value)

        case .failure(let apiFailure):
            return failure?(apiFailure)

        case .refresh(let value):
            return refresh?(value)
        }
    }

    /// Executes a handler for the current state or falls back to `orElse`.
    ///
    /// This is useful when only a subset of states require
    /// specialized handling.
    ///
    /// - Parameters:
    ///   - initialOrLoading: Optional handler for `.initial` and `.loading`.
    ///   - success: Optional handler for `.success`.
    ///   - failure: Optional handler for `.failure`.
    ///   - refresh: Optional handler for `.refresh`.
    ///   - orElse: Called when no matching handler is provided.
    /// - Returns: The result from the matching handler or `orElse`.
    func maybeWhen<Result>(
        initialOrLoading: (() -> Result)? = nil,
        success: ((Value) -> Result)? = nil,
        failure: ((any Failure) -> Result)? = nil,
        refresh: ((Value) -> Result)? = nil,
        orElse: () -> Result
    ) -> Result {
        switch self {
        case .initial, .loading:
            return initialOrLoading?() ?? orElse()

        case .success(let value):
            return success?(value) ?? orElse()

        case .failure(let apiFailure):
            return failure?(apiFailure) ?? orElse()

        case .refresh(let value):
            return refresh?(value) ?? orElse()
        }
    }

    /// Executes an action when the state contains data.
    ///
    /// The action is executed for both `.success` and `.refresh`.
    ///
    /// - Parameter action: The operation to perform with the value.
    /// - Returns: The result of `action`, or `nil` when no data exists.
    func whenData<Result>(
        _ action: (Value) -> Result
    ) -> Result? {
        switch self {
        case .success(let value),
             .refresh(let value):
            return action(value)

        default:
            return nil
        }
    }
}
