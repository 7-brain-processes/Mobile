//
//  DefaultAuthRepositoryImpl.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct DefaultAuthRepository: AuthRepository, Sendable {

    private let apiClient: APIClient
    private let decoder: JSONDecoder

    init(
        apiClient: APIClient,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.apiClient = apiClient
        self.decoder = decoder
    }

    func login(request: LoginCommand) async throws -> AuthResponse {

        let endpoint = AuthEndpoint.login(
            LoginMapper.toDTO(request)
        )

        let (data, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [200])

        let dto = try decoder.decode(AuthResponseDTO.self, from: data)

        return try AuthResponseMapper.toDomain(dto)
    }

    func register(request: RegisterCommand) async throws -> AuthResponse {

        let endpoint = AuthEndpoint.register(
            RegisterMapper.toDTO(request)
        )

        let (data, response) = try await apiClient.send(endpoint)

        guard response.statusCode == 200 || response.statusCode == 201 else {
            if response.statusCode == 401 {
                throw APIError.unauthorized
            }
            throw APIError.serverError(code: response.statusCode)
        }

        let dto = try decoder.decode(AuthResponseDTO.self, from: data)

        return try AuthResponseMapper.toDomain(dto)
    }

    func getMe() async throws -> User {

        let endpoint = AuthEndpoint.me

        let (data, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [200])

        let dto = try decoder.decode(UserDTO.self, from: data)

        return try UserMapper.toDomain(dto)
    }
}
