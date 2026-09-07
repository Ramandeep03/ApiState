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
             .refresh(let value):
            return .refresh(value)

        default:
            return .loading
        }
    }
}
