//
//  ValidationFailure.swift
//  ApiState
//
//  Created by ramandeep on 07/09/26.
//


/// Represents a validation failure.
///
/// Use this failure when user input or application data
/// does not satisfy required validation rules.
public struct ValidationFailure: Failure {
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