//
//  APIError.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public enum APIError: Error, Equatable, Sendable {
    case invalidResponse
    case unauthorized
    case serverError(code: Int)
    case underlying(Error)
    
    public static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidResponse, .invalidResponse), (.unauthorized, .unauthorized):
            return true
        case let (.serverError(code1), .serverError(code2)):
            return code1 == code2
        default:
            return false
        }
    }
}
