//
//  AuthEndpoint.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


import Foundation

enum AuthEndpoint: Endpoint {
    case login(LoginRequest, baseURL: URL)
    case register(RegisterRequest, baseURL: URL)
    case me(baseURL: URL)
    
    var baseURL: URL {
        switch self {
        case .login(_, let url), .register(_, let url), .me(let url):
            return url
        }
    }
    
    var path: String {
        switch self {
        case .login: return "/auth/login"
        case .register: return "/auth/register"
        case .me: return "/auth/me"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .register: return .post
        case .me: return .get
        }
    }
    
    var headers: [String: String]? {
        return ["Accept": "application/json"]
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        switch self {
        case .login(let request, _):
            return try? encoder.encode(request)
        case .register(let request, _):
            return try? encoder.encode(request)
        case .me:
            return nil
        }
    }
}
