/// Transformation utilities for `ApiState`.
public extension ApiState {

    /// Transforms data contained by `.success`, `.refresh`, `.loadMore`,
    /// or a `.failure` with retained prior data.
    ///
    /// Other states are preserved without modification.
    ///
    /// - Parameter transform: A closure that transforms the current value.
    /// - Returns: An `ApiState` containing the transformed value.
    func map<NewValue>(
        _ transform: (Value) throws -> NewValue
    ) rethrows -> ApiState<NewValue> {
        switch self {
        case .initial:
            return .initial

        case .loading:
            return .loading

        case .success(let value):
            return .success(
                try transform(value)
            )

        case .failure(let failure, let previousData):
            return .failure(failure, previousData: try previousData.map(transform))

        case .refresh(let value):
            return .refresh(
                try transform(value)
            )

        case .loadMore(let value):
            return .loadMore(
                try transform(value)
            )
        }
    }

    /// Transforms the failure contained by a `.failure` state.
    ///
    /// All non-failure states are returned unchanged.
    ///
    /// - Parameter transform: A closure that transforms the failure.
    /// - Returns: An `ApiState` containing the transformed failure.
    func mapFailure(
        _ transform: (any Failure) -> any Failure
    ) -> ApiState<Value> {
        switch self {
        case .failure(let failure, let previousData):
            return .failure(
                transform(failure),
                previousData: previousData
            )

        default:
            return self
        }
    }
}
