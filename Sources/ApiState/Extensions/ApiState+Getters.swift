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

    /// Returns `true` when the state is `.loadMore`.
    var isLoadMore: Bool {
        if case .loadMore = self {
            return true
        }

        return false
    }

    /// Returns `true` when the state contains data.
    ///
    /// Success, refresh, load-more, and failures retaining prior data contain data.
    var hasData: Bool {
        switch self {
        case .success, .refresh, .loadMore:
            return true

        case .failure(_, let previousData):
            return previousData != nil

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

    /// Returns data held by `.success`, `.refresh`, `.loadMore`, or a
    /// `.failure` with retained prior data.
    ///
    /// Returns `nil` for all other states.
    var data: Value? {
        switch self {
        case .success(let value),
             .refresh(let value),
             .loadMore(let value):
            return value

        case .failure(_, let previousData):
            return previousData

        default:
            return nil
        }
    }

    /// Returns the associated failure when the state is `.failure`.
    ///
    /// Returns `nil` for all other states.
    var error: (any Failure)? {
        if case .failure(let failure, _) = self {
            return failure
        }

        return nil
    }
}
