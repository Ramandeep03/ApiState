//
//  DefaultFailure.swift
//  ApiState
//
//  Created by ramandeep on 07/09/26.
//


/// A general-purpose failure that can be used when no
/// domain-specific failure type is required.
public struct DefaultFailure: Failure {
    public let message: String
    public let code: Int?
    public let stackTrace: [String]?

    public init(
        _ message: String,
        code: Int? = nil,
        stackTrace: [String]? = nil
    ) {
        self.message = message
        self.code = code
        self.stackTrace = stackTrace
    }
}