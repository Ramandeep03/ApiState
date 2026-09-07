/// Convenience properties for inspecting an `ApiState`.
public extension ApiState {

    /// Returns `true` when the state is `.initial`.
    var isInitial: Bool {
        if case .initial = self {
            return true
        }

        return false
    }

    /// Returns `true` when the state is `.loading`.
    var isLoading: Bool {
        if case .loading = self {
            return true
        }

        return false
    }

    /// Returns `true` when the state is `.success`.
    var isSuccess: Bool {
        if case .success = self {
            return true
        }

        return false
    }

    /// Returns `true` when the state is `.failure`.
    var isFailure: Bool {
        if case .failure = self {
            return true
        }

        return false
    }

    /// Returns `true` when the state is `.refresh`.
    var isRefresh: Bool {
        if case .refresh = self {
            return true
        }

        return false
    }

    /// Returns `true` when the state contains data.
    ///
    /// Both `.success` and `.refresh` contain data.
    var hasData: Bool {
        switch self {
        case .success, .refresh:
            return true

        default:
            return false
        }
    }

    /// Returns `true` when the state contains a failure.
    var hasError: Bool {
        if case .failure = self {
            return true
        }

        return false
    }

    /// Returns the associated value when the state is `.success`
    /// or `.refresh`.
    ///
    /// Returns `nil` for all other states.
    var data: Value? {
        switch self {
        case .success(let value),
             .refresh(let value):
            return value

        default:
            return nil
        }
    }

    /// Returns the associated failure when the state is `.failure`.
    ///
    /// Returns `nil` for all other states.
    var error: (any Failure)? {
        if case .failure(let failure) = self {
            return failure
        }

        return nil
    }
}
