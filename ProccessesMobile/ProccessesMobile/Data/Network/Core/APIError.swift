//
//  APIError.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//


import Foundation

enum APIError: Error, Equatable, Sendable {
    case invalidURL
    case invalidResponse
    case unauthorized
    case serverError(code: Int)
    case underlying(Error)
    
    public static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidResponse, .invalidResponse),
             (.unauthorized, .unauthorized),
             (.invalidURL, .invalidURL):
            return true
        case let (.serverError(code1), .serverError(code2)):
            return code1 == code2
        default:
            return false
        }
    }
}
