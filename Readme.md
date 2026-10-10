
# ApiState

A lightweight, type-safe state management utility for handling asynchronous operations in Swift.

`ApiState` provides a simple and predictable way to represent API and asynchronous operation states such as **initial**, **loading**, **success**, **failure**, **refresh**, and **load more**.

It is designed to work naturally with SwiftUI, MVVM, repositories, services, and other Swift architectures without introducing external dependencies.

## Features

- Six predictable states
  - `initial`
  - `loading`
  - `success`
  - `failure`
  - `refresh`
  - `loadMore`
- Type-safe generic data
- Structured failure handling
- Built-in common failure types
- Pattern matching helpers
- Data and failure transformations
- Refresh state with existing data preservation
- Load-more state with existing data preservation
- Failure states can retain previously loaded data
- Async operation guard
- Swift Concurrency support
- `Sendable` support
- Zero external dependencies
- iOS, macOS, tvOS, and watchOS support

## Requirements

- Swift 6
- iOS 13+
- macOS 10.15+
- tvOS 13+
- watchOS 6+

## Installation

### Swift Package Manager

In Xcode:

1. Open your project.
2. Go to **File → Add Package Dependencies**.
3. Enter the repository URL.
4. Select the version you want to use.
5. Add `ApiState` to your application target.

Then import the package:

```swift
import ApiState
```

## Basic Usage

Create an API state with the type of data your operation returns.

```swift
var usersState: ApiState<[User]> = .initial
```

The state can then transition through the lifecycle of an asynchronous operation.

```swift
usersState = .loading

do {
    let users = try await repository.fetchUsers()
    usersState = .success(users)
} catch {
    usersState = .failure(
        ServerFailure(error.localizedDescription)
    )
}
```

## States

### Initial

Represents an operation that has not started.

```swift
let state: ApiState<User> = .initial
```

### Loading

Represents an operation currently in progress.

```swift
let state: ApiState<User> = .loading
```

### Success

Represents an operation that completed successfully.

```swift
let state: ApiState<User> = .success(user)
```

### Failure

Represents an operation that failed.

```swift
let state: ApiState<User> = .failure(
    NetworkFailure()
)
```

Keep data from an earlier successful request when a later request fails:

```swift
let state: ApiState<User> = .failure(
    NetworkFailure(),
    previousData: user
)
```

### Refresh

Represents existing data that is currently being refreshed.

Unlike `loading`, the `refresh` state keeps the previously loaded data available.

```swift
let state: ApiState<User> = .refresh(user)
```

### Load More

Represents a pagination request while keeping the current data available.

```swift
let state: ApiState<[User]> = .loadMore(existingUsers)
```

## Convenience Properties

`ApiState` includes properties for quickly checking the current state.

```swift
state.isInitial
state.isLoading
state.isSuccess
state.isFailure
state.isRefresh
state.isLoadMore
```

Check whether data or an error is available:

```swift
state.hasData
state.hasError
```

Access the current data:

```swift
if let user = state.data {
    print(user)
}
```

Access the current failure:

```swift
if let failure = state.error {
    print(failure.message)
}
```

`data` is available for `success`, `refresh`, `loadMore`, and a `failure`
that retains prior data.

## Pattern Matching

### when

Handle every possible state.

```swift
let message = state.when(
    initialOrLoading: {
        "Loading..."
    },
    success: { user in
        "Welcome \(user.name)"
    },
    failure: { failure in
        failure.message
    },
    refresh: { user in
        "Refreshing \(user.name)"
    },
    loadMore: { user in
        "Loading more for \(user.name)"
    }
)
```

The `refresh` and `loadMore` handlers are optional. If either is omitted,
its data is passed to the `success` handler. Use `failureWithData` to handle
a failure and its optional retained data together.

```swift
state.when(
    initialOrLoading: {
        showLoading()
    },
    success: { user in
        showUser(user)
    },
    failure: { failure in
        showError(failure.message)
    }
)
```

## whenOrNull

Use `whenOrNull` when you only want to handle specific states.

```swift
state.whenOrNull(
    success: { user in
        print(user.name)
    },
    failure: { failure in
        print(failure.message)
    }
)
```

Handle pagination and failures with retained data explicitly:

```swift
state.whenOrNull(
    loadMore: { users in print("Loading after \(users.count) users") },
    failureWithData: { failure, users in
        print("\(failure.message); cached count: \(users?.count ?? 0)")
    }
)
```

If the current state does not have a matching handler, `nil` is returned.

## maybeWhen

Use `maybeWhen` when only some states require special handling and everything else should use a fallback.

```swift
let message = state.maybeWhen(
    success: { user in
        "Welcome \(user.name)"
    },
    failure: { failure in
        failure.message
    },
    orElse: {
        "Please wait..."
    }
)
```

## whenData

Execute an operation only when the state contains data.

```swift
state.whenData { user in
    print(user.name)
}
```

`whenData` works with every state that contains data, including `loadMore`
and failures that retain prior data.

It can also return a transformed value.

```swift
let name = state.whenData { user in
    user.name
}
```

## Transforming Data

Use `map` to transform data held by `success`, `refresh`, `loadMore`, or a
failure with retained data.

```swift
let userState: ApiState<User> = .success(user)

let nameState: ApiState<String> = userState.map { user in
    user.name
}
```

The current state is preserved.

For example:

```text
success(User) → success(String)
refresh(User) → refresh(String)
loadMore(User) → loadMore(String)
failure(error, User) → failure(error, String)
loading       → loading
failure       → failure
initial       → initial
```

## Transforming Failures

Use `mapFailure` to transform a failure.

```swift
let updatedState = state.mapFailure { failure in
    DefaultFailure(
        "Unable to load user.",
        code: failure.code,
        stackTrace: failure.stackTrace
    )
}
```

Non-failure states remain unchanged.

## State Transitions

### toLoading

Convert any state to loading.

```swift
state = state.toLoading()
```

### toRefresh

Convert a state containing data into a refresh state.

```swift
state = state.toRefresh()
```

For `success` and `refresh`, the existing data is preserved.

```text
success(data) → refresh(data)
refresh(data) → refresh(data)
initial       → loading
loading       → loading
failure       → loading
failure(error, data) → refresh(data)
```

### toLoadMore

Convert a state containing data into a load-more state while retaining that
data. States without data become `.loading`.

```swift
state = state.toLoadMore()
```

```text
success(data)          → loadMore(data)
refresh(data)          → loadMore(data)
loadMore(data)         → loadMore(data)
failure(error, data)   → loadMore(data)
initial                → loading
loading                → loading
failure(error)         → loading
```

## Async Guard

`guardAsync` provides a convenient way to convert a throwing asynchronous operation directly into an `ApiState`.

```swift
let state = await ApiState<User>.guardAsync(
    {
        try await repository.fetchUser()
    },
    previousData: currentState.data,
    onError: { error, stackTrace in
        ServerFailure(
            error.localizedDescription,
            stackTrace: stackTrace
        )
    }
)
```

A successful operation becomes:

```swift
.success(user)
```

A thrown error becomes:

```swift
.failure(...)
```

The error mapper receives the original `Error` and the captured stack trace.
Pass `previousData` to retain the displayed value if the operation fails.

## Failures

`Failure` defines the common interface used by `ApiState`.

```swift
public protocol Failure: Error, LocalizedError, Sendable {
    var message: String { get }
    var code: Int? { get }
    var stackTrace: [String]? { get }
}
```

ApiState includes several ready-to-use failure types.

### DefaultFailure

Use when no specialized failure type is necessary.

```swift
let failure = DefaultFailure(
    "Something went wrong."
)
```

### NetworkFailure

Use for connectivity and network-related failures.

```swift
let failure = NetworkFailure()
```

Or provide additional information:

```swift
let failure = NetworkFailure(
    "Unable to connect to the internet.",
    code: -1009
)
```

### ServerFailure

Use for failures returned by a remote server.

```swift
let failure = ServerFailure(
    "Internal server error.",
    code: 500
)
```

### ValidationFailure

Use for validation problems.

```swift
let failure = ValidationFailure(
    "Email address is invalid."
)
```

### CacheFailure

Use for local cache or persistence failures.

```swift
let failure = CacheFailure(
    "Unable to read cached users."
)
```

## Custom Failures

You can define application-specific failures by conforming to `Failure`.

```swift
struct AuthenticationFailure: Failure {
    let message: String
    let code: Int?
    let stackTrace: [String]?

    init(
        _ message: String,
        code: Int? = nil,
        stackTrace: [String]? = nil
    ) {
        self.message = message
        self.code = code
        self.stackTrace = stackTrace
    }
}
```

Then use it normally:

```swift
let state: ApiState<User> = .failure(
    AuthenticationFailure(
        "Your session has expired."
    )
)
```

## SwiftUI Example

`ApiState` works naturally with SwiftUI.

```swift
import SwiftUI
import ApiState

@MainActor
final class UserViewModel: ObservableObject {

    @Published
    private(set) var state: ApiState<User> = .initial

    private let repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository
    }

    func loadUser() async {
        state = .loading

        state = await ApiState<User>.guardAsync(
            {
                try await repository.fetchUser()
            },
            onError: { error, stackTrace in
                ServerFailure(
                    error.localizedDescription,
                    stackTrace: stackTrace
                )
            }
        )
    }

    func refresh() async {
        state = state.toRefresh()

        state = await ApiState<User>.guardAsync(
            {
                try await repository.fetchUser()
            },
            onError: { error, stackTrace in
                ServerFailure(
                    error.localizedDescription,
                    stackTrace: stackTrace
                )
            }
        )
    }
}
```

The state can then drive the UI:

```swift
struct UserView: View {

    @StateObject
    private var viewModel: UserViewModel

    var body: some View {
        content
            .task {
                await viewModel.loadUser()
            }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .initial, .loading:
            ProgressView()

        case .success(let user):
            UserContentView(user: user)

        case .refresh(let user):
            UserContentView(user: user)

        case .failure(let failure, _):
            Text(failure.message)

        case .loadMore(let users):
            UserContentView(user: users)
        }
    }
}
```

## Why ApiState?

Asynchronous operations commonly require several related pieces of state:

```swift
var isLoading = false
var user: User?
var error: Error?
var isRefreshing = false
```

These values can easily become inconsistent.

`ApiState` represents the operation as a single state:

```swift
var state: ApiState<User> = .initial
```

Making transitions explicit:

```text
initial
   ↓
loading
   ↓
success ───→ refresh
success ───→ loadMore
   ↓
failure
```

This keeps state handling predictable, type-safe, and easy to reason about.

## Architecture

ApiState does not impose an application architecture.

It can be used with:

- SwiftUI
- UIKit
- MVVM
- Clean Architecture
- Repository Pattern
- Observable / Observation
- Combine
- async/await

The package only represents the state of an operation. How that state is stored and observed remains up to your application.

## License

ApiState is available under the MIT License.
