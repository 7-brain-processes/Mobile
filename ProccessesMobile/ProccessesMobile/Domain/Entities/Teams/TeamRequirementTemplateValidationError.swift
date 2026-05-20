//
//  TeamRequirementTemplateValidationError.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 14.05.2026.
//


import Foundation

enum TeamRequirementTemplateValidationError: LocalizedError, Equatable {
    case emptyName
    case invalidMinTeamSize
    case invalidMaxTeamSize
    case minGreaterThanMax

    var errorDescription: String? {
        switch self {
        case .emptyName:
            return "Название шаблона не может быть пустым"
        case .invalidMinTeamSize:
            return "Минимальный размер команды должен быть больше 0"
        case .invalidMaxTeamSize:
            return "Максимальный размер команды должен быть больше 0"
        case .minGreaterThanMax:
            return "Минимальный размер команды не может быть больше максимального"
        }
    }
}