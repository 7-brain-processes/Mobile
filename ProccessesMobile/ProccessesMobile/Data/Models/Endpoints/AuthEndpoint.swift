//
//  AuthEndpoint.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

enum AuthEndpoint: Endpoint {
    case login(LoginRequestDTO)
    case register(RegisterRequestDTO)
    case me

    var path: String {
        switch self {
        case .login:
            return "auth/login"
        case .register:
            return "auth/register"
        case .me:
            return "auth/me"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .login, .register:
            return .POST
        case .me:
            return .GET
        }
    }

    var headers: [String: String] {
        [
            "Accept": "application/json"
        ]
    }

    var queryItems: [URLQueryItem] {
        []
    }

    var body: EndpointBody {
        switch self {
        case .login(let request):
            return .json(request)
        case .register(let request):
            return .json(request)
        case .me:
            return .none
        }
    }

    var requiresAuth: Bool {
        switch self {
        case .login, .register:
            return false
        case .me:
            return true
        }
    }
}
