//
//  ServerFailure.swift
//  ApiState
//
//  Created by ramandeep on 07/09/26.
//


/// Represents a failure returned by a remote server.
///
/// The optional `code` can be used for HTTP status codes
/// or application-specific server error codes.
public struct ServerFailure: Failure {
    public let message: String
    public let code: Int?
    public let stackTrace: [String]?

    public init(
        _ message: String = "Server request failed.",
        code: Int? = nil,
        stackTrace: [String]? = nil
    ) {
        self.message = message
        self.code = code
        self.stackTrace = stackTrace
    }
}