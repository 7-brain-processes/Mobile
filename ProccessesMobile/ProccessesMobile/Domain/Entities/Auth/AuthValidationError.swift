//
//  AuthValidationError.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

enum AuthValidationError: Error, Equatable, Sendable {
    case emptyCredentials
    case usernameInvalidLength(min: Int, max: Int)
    case passwordInvalidLength(min: Int, max: Int)
}
