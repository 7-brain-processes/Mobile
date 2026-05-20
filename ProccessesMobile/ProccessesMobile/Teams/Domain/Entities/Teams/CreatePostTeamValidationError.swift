//
//  CreatePostTeamValidationError.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 20.05.2026.
//

import Foundation

enum CreatePostTeamValidationError: LocalizedError, Equatable {
    case emptyName
    case invalidMaxSize

    var errorDescription: String? {
        switch self {
        case .emptyName:
            return "Team name is required"
        case .invalidMaxSize:
            return "Max size must be greater than zero"
        }
    }
}
