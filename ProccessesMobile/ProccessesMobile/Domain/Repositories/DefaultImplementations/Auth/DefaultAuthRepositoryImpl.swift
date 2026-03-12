//
//  DefaultAuthRepositoryImpl.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct DefaultAuthRepository: AuthRepository, Sendable {

    private let client: HTTPClient
    private let baseURL: URL

    init(client: HTTPClient, baseURL: URL) {
        self.client = client
        self.baseURL = baseURL
    }

    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }

    func login(request: LoginCommand) async throws -> AuthResponse {

        let endpoint = AuthEndpoint.login(LoginMapper.toDTO(request), baseURL: baseURL)
        let urlRequest = try endpoint.makeURLRequest()

        let (data, response) = try await client.send(urlRequest)

        if response.statusCode == 401 { throw APIError.unauthorized }
        try validate(response, success: 200)

        return try decoder.decode(AuthResponse.self, from: data)
    }

    func register(request: RegisterCommand) async throws -> AuthResponse {

        let endpoint = AuthEndpoint.register(RegisterMapper.toDTO(request), baseURL: baseURL)
        let urlRequest = try endpoint.makeURLRequest()

        let (data, response) = try await client.send(urlRequest)

        if response.statusCode == 409 {
            throw APIError.serverError(code: 409)
        }

        guard response.statusCode == 201 || response.statusCode == 200 else {
            throw APIError.serverError(code: response.statusCode)
        }

        return try decoder.decode(AuthResponse.self, from: data)
    }

    func getMe() async throws -> User {

        let request = try AuthEndpoint.me(baseURL: baseURL).makeURLRequest()

        let (data, response) = try await client.send(request)

        if response.statusCode == 401 { throw APIError.unauthorized }
        try validate(response, success: 200)

        return try decoder.decode(User.self, from: data)
    }
}
