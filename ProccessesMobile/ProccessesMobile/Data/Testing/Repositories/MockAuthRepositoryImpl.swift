//
//  MockAuthRepositoryImpl.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct MockAuthRepositoryImpl: AuthRepository, Sendable {
    private let client: HTTPClient
    private let baseURL: URL
    
    init(client: HTTPClient, baseURL: URL) {
        self.client = client
        self.baseURL = baseURL
    }
    
    func login(request: LoginRequest) async throws -> AuthResponse {
        let endpoint = AuthEndpoint.login(request, baseURL: baseURL)
        let urlRequest = try endpoint.makeURLRequest()
        
        let (data, response) = try await client.send(urlRequest)
        
        if response.statusCode == 401 { throw APIError.unauthorized }
        guard response.statusCode == 200 else { throw APIError.serverError(code: response.statusCode) }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601 
        return try decoder.decode(AuthResponse.self, from: data)
    }
    
    func register(request: RegisterRequest) async throws -> AuthResponse {
        let endpoint = AuthEndpoint.register(request, baseURL: baseURL)
        let urlRequest = try endpoint.makeURLRequest()
        
        let (data, response) = try await client.send(urlRequest)
        
        if response.statusCode == 409 { throw APIError.serverError(code: 409) }
        guard response.statusCode == 201 || response.statusCode == 200 else { 
            throw APIError.serverError(code: response.statusCode) 
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(AuthResponse.self, from: data)
    }
    func getMe() async throws -> User {
           let request = try AuthEndpoint.me(baseURL: baseURL).makeURLRequest()
           let (data, response) = try await client.send(request)
           
           if response.statusCode == 401 { throw APIError.unauthorized }
           guard response.statusCode == 200 else { throw APIError.serverError(code: response.statusCode) }
           
           return try JSONDecoder().decode(User.self, from: data)
       }
}
