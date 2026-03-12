//
//  AuthRepositoryContractTests.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


import Testing
import Foundation
@testable import ProccessesMobile

@Suite("Auth Data: Repository Executable Specification")
struct AuthRepositoryExecutableTests {

    private let anyURL = URL(string: "http://localhost:8080/api/v1")!

    // MARK: - SUT Factory

    private func makeSUT(client: HTTPClient, baseURL: URL) -> AuthRepository {
        DefaultAuthRepository(client: client, baseURL: baseURL)
    }

    private func makeValidAuthJSON() -> Data {
        """
        {
            "token": "jwt_token_abc123",
            "user": {
                "id": "550e8400-e29b-41d4-a716-446655440000",
                "username": "testuser",
                "displayName": "Test User",
                "createdAt": "2026-03-06T10:00:00Z"
            }
        }
        """.data(using: .utf8)!
    }

    private func makeValidUserJSON() -> Data {
        """
        {
            "id": "550e8400-e29b-41d4-a716-446655440000",
            "username": "testuser",
            "displayName": "Test User",
            "createdAt": "2026-03-06T10:00:00Z"
        }
        """.data(using: .utf8)!
    }

    // MARK: - Login Tests

    @Test("Login successfully parses 200 OK JSON and routes to correct endpoint")
    func loginSuccess() async throws {
        let jsonResponse = makeValidAuthJSON()
        let response = HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!

        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(.success((jsonResponse, response)))

        let sut = makeSUT(client: clientSpy, baseURL: anyURL)
        let command = LoginCommand(username: "testuser", password: "pwd")

        let result = try await sut.login(request: command)

        #expect(!result.token.isEmpty)
        #expect(result.user.id == UUID(uuidString: "550e8400-e29b-41d4-a716-446655440000"))
        #expect(result.user.username == "testuser")
        #expect(result.user.displayName == "Test User")

        let recordedRequests = clientSpy.getRecordedRequests()
        #expect(recordedRequests.count == 1)
        #expect(recordedRequests.first?.url?.absoluteString == "http://localhost:8080/api/v1/auth/login")
        #expect(recordedRequests.first?.httpMethod == "POST")
    }

    @Test("Login maps 401 HTTP response to Domain Unauthorized error")
    func loginMapsUnauthorized() async {
        let errorJson = """
        { "timestamp": "2026-03-06", "status": 401, "error": "Unauthorized", "message": "Invalid credentials", "path": "/api/v1/auth/login" }
        """.data(using: .utf8)!
        let response = HTTPURLResponse(url: anyURL, statusCode: 401, httpVersion: nil, headerFields: nil)!

        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(.success((errorJson, response)))

        let sut = makeSUT(client: clientSpy, baseURL: anyURL)

        await #expect(throws: APIError.unauthorized) {
            _ = try await sut.login(request: LoginCommand(username: "test", password: "pwd"))
        }
    }

    // MARK: - Register Tests

    @Test("Register successfully parses 201 Created JSON and routes correctly")
    func registerSuccess() async throws {
        let jsonResponse = makeValidAuthJSON()
        let response = HTTPURLResponse(url: anyURL, statusCode: 201, httpVersion: nil, headerFields: nil)!

        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(.success((jsonResponse, response)))

        let sut = makeSUT(client: clientSpy, baseURL: anyURL)
        let command = RegisterCommand(username: "testuser", password: "pwd", displayName: "Test User")

        let result = try await sut.register(request: command)

        #expect(!result.token.isEmpty)
        #expect(result.user.username == "testuser")
        #expect(result.user.displayName == "Test User")

        let recordedRequests = clientSpy.getRecordedRequests()
        #expect(recordedRequests.count == 1)
        #expect(recordedRequests.first?.url?.absoluteString == "http://localhost:8080/api/v1/auth/register")
        #expect(recordedRequests.first?.httpMethod == "POST")
    }

    @Test("Register maps 409 HTTP response to Domain Conflict error")
    func registerMapsConflict() async {
        let errorJson = """
        { "timestamp": "2026-03-06", "status": 409, "error": "Conflict", "message": "Username already taken" }
        """.data(using: .utf8)!
        let response = HTTPURLResponse(url: anyURL, statusCode: 409, httpVersion: nil, headerFields: nil)!

        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(.success((errorJson, response)))

        let sut = makeSUT(client: clientSpy, baseURL: anyURL)

        await #expect(throws: APIError.serverError(code: 409)) {
            _ = try await sut.register(
                request: RegisterCommand(username: "taken", password: "pwd", displayName: nil)
            )
        }
    }

    // MARK: - Get Me Tests

    @Test("GetMe routes to GET /auth/me and parses User correctly")
    func getMeRoutingAndParsing() async throws {
        let jsonResponse = makeValidUserJSON()
        let response = HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!

        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(.success((jsonResponse, response)))

        let sut = makeSUT(client: clientSpy, baseURL: anyURL)
        let result = try await sut.getMe()

        #expect(result.id == UUID(uuidString: "550e8400-e29b-41d4-a716-446655440000"))
        #expect(result.username == "testuser")
        #expect(result.displayName == "Test User")

        let recordedRequests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(recordedRequests.first)

        #expect(sentRequest.httpMethod == "GET")
        #expect(sentRequest.url?.absoluteString == "http://localhost:8080/api/v1/auth/me")
    }

    @Test("GetMe maps 401 HTTP response to Domain Unauthorized error")
    func getMeMapsUnauthorized() async {
        let response = HTTPURLResponse(url: anyURL, statusCode: 401, httpVersion: nil, headerFields: nil)!

        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(.success((Data(), response)))

        let sut = makeSUT(client: clientSpy, baseURL: anyURL)

        await #expect(throws: APIError.unauthorized) {
            _ = try await sut.getMe()
        }
    }
}
