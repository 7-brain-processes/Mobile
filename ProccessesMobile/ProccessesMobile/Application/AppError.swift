//
//  AppError.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 18.04.2026.
//


import Foundation

enum AppError: LocalizedError, Equatable {
    case forbidden
    case notFound
    case serverError(statusCode: Int)

    var errorDescription: String? {
        switch self {
        case .forbidden:
            return "Недостаточно прав."
        case .notFound:
            return "Ресурс не найден."
        case .serverError(let statusCode):
            return "Ошибка сервера: \(statusCode)."
        }
    }
}