//
//  AuthValidationError.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

enum AuthValidationErrorDTO: Error, Equatable, Sendable {
    case emptyCredentials
    case usernameInvalidLength(min: Int, max: Int)
    case passwordInvalidLength(min: Int, max: Int)
}
