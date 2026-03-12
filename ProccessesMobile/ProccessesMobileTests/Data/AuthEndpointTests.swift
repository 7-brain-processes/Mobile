//
//  AuthEndpointTests.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


import Testing
import Foundation
@testable import ProccessesMobile

@Suite("Auth Data: Endpoints")
struct AuthEndpointTests {
    let baseURL = URL(string: "http://localhost:8080/api/v1")!

    @Test("Login endpoint maps correctly to URLRequest")
    func loginEndpointMapping() throws {
        let requestDTO = LoginRequestDTO(
            username: "johndoe",
            password: "password123"
        )
        let endpoint = AuthEndpoint.login(requestDTO, baseURL: baseURL)

        let urlRequest = try endpoint.makeURLRequest()

        #expect(urlRequest.url?.absoluteString == "http://localhost:8080/api/v1/auth/login")
        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")

        let decodedBody = try JSONDecoder().decode(LoginRequestDTO.self, from: #require(urlRequest.httpBody))
        #expect(decodedBody.username == "johndoe")
        #expect(decodedBody.password == "password123")
    }

    @Test("Register endpoint maps correctly to URLRequest")
    func registerEndpointMapping() throws {
        let requestDTO = RegisterRequestDTO(
            username: "janedoe",
            password: "password123",
            displayName: "Jane Doe"
        )
        let endpoint = AuthEndpoint.register(requestDTO, baseURL: baseURL)

        let urlRequest = try endpoint.makeURLRequest()

        #expect(urlRequest.url?.absoluteString == "http://localhost:8080/api/v1/auth/register")
        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")

        let decodedBody = try JSONDecoder().decode(RegisterRequestDTO.self, from: #require(urlRequest.httpBody))
        #expect(decodedBody.username == "janedoe")
        #expect(decodedBody.password == "password123")
        #expect(decodedBody.displayName == "Jane Doe")
    }

    @Test("Me endpoint maps correctly to URLRequest")
    func meEndpointMapping() throws {
        let endpoint = AuthEndpoint.me(baseURL: baseURL)
        let urlRequest = try endpoint.makeURLRequest()

        #expect(urlRequest.url?.absoluteString == "http://localhost:8080/api/v1/auth/me")
        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.httpBody == nil)
    }
}
