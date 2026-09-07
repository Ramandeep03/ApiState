//
//  CacheFailure.swift
//  ApiState
//
//  Created by ramandeep on 07/09/26.
//


/// Represents a failure while reading from or writing
/// to local cached data.
public struct CacheFailure: Failure {
    public let message: String
    public let code: Int?
    public let stackTrace: [String]?

    public init(
        _ message: String = "Cache operation failed.",
        code: Int? = nil,
        stackTrace: [String]? = nil
    ) {
        self.message = message
        self.code = code
        self.stackTrace = stackTrace
    }
}