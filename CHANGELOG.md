# Changelog

## 2.0.0

- Added `loadMore(Value)` to represent pagination while retaining existing data.
- Added `toLoadMore()` and `isLoadMore` helpers.
- Failures can now retain prior data with `.failure(failure, previousData:)`.
- Added `failureWithData` callbacks and extended data access, mapping, and
  `whenData` helpers to handle retained data and load-more states.
- Added the `previousData` argument to `guardAsync` so failed requests can
  preserve the value already on screen.
- Updated the README with the new states, helpers, and examples.
