//
//  CourseCategoriesServiceError.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 18.04.2026.
//


import Foundation

enum CourseCategoriesServiceError: LocalizedError, Equatable {
    case forbidden
    case notFound
    case invalidResponse
    case decodingFailed
    case unexpectedStatus(Int)

    var errorDescription: String? {
        switch self {
        case .forbidden:
            return "Нет доступа к категориям этого курса."
        case .notFound:
            return "Курс или категории не найдены."
        case .invalidResponse:
            return "Некорректный ответ сервера."
        case .decodingFailed:
            return "Не удалось обработать список категорий."
        case .unexpectedStatus(let code):
            return "Неожиданный код ответа сервера: \(code)."
        }
    }
}