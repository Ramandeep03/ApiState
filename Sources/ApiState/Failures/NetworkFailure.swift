//
//  NetworkFailure.swift
//  ApiState
//
//  Created by ramandeep on 07/09/26.
//


/// Represents a network-related failure.
///
/// Use this failure for connectivity issues such as
/// unavailable internet access or unreachable hosts.
public struct NetworkFailure: Failure {
    public let message: String
    public let code: Int?
    public let stackTrace: [String]?

    public init(
        _ message: String = "Network request failed.",
        code: Int? = nil,
        stackTrace: [String]? = nil
    ) {
        self.message = message
        self.code = code
        self.stackTrace = stackTrace
    }
}