/// State-transition utilities for `ApiState`.
public extension ApiState {

    /// Converts the current state to `.loading`.
    ///
    /// Any existing data or failure is discarded.
    ///
    /// - Returns: A loading state.
    func toLoading() -> ApiState<Value> {
        .loading
    }

    /// Converts the current state to a refresh state when data exists.
    ///
    /// `.success` and `.refresh` preserve their current value and become
    /// `.refresh`. States without data become `.loading`.
    ///
    /// - Returns: A refresh state when data exists, otherwise `.loading`.
    func toRefresh() -> ApiState<Value> {
        switch self {
        case .success(let value),
             .refresh(let value),
             .loadMore(let value):
            return .refresh(value)

        case .failure(_, let previousData?):
            return .refresh(previousData)

        default:
            return .loading
        }
    }

    /// Converts the current state to a load-more state when data exists.
    ///
    /// States without data become `.loading`.
    ///
    /// - Returns: A load-more state when data exists, otherwise `.loading`.
    func toLoadMore() -> ApiState<Value> {
        switch self {
        case .success(let value),
             .refresh(let value),
             .loadMore(let value):
            return .loadMore(value)

        case .failure(_, let previousData?):
            return .loadMore(previousData)

        default:
            return .loading
        }
    }
}
