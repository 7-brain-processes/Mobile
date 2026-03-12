//
//  AuthUseCasesTests.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


import Testing
import Foundation
@testable import ProccessesMobile

@Suite("Auth Domain: Executable Specification")
struct AuthUseCasesExecutableTests {

    // MARK: - SUT Factories

    private func makeLoginSUT(repo: AuthRepository, storage: TokenStorage) -> LoginUseCase {
        DefaultLoginUseCase(repository: repo, tokenStorage: storage)
    }

    private func makeRegisterSUT(repo: AuthRepository, storage: TokenStorage) -> RegisterUseCase {
        DefaultRegisterUseCase(repository: repo, tokenStorage: storage)
    }

    private func makeGetMeSUT(repo: AuthRepository) -> GetMeUseCase {
        DefaultGetMeUseCase(repository: repo)
    }

    // MARK: - Login Tests

    @Test("Login orchestrates repository and storage correctly")
    func loginSuccess() async throws {

        let expectedUser = User(
            id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440111")!,
            username: "valid_user",
            displayName: nil
        )

        let expectedResponse = AuthResponse(
            token: "success_token",
            user: expectedUser
        )

        let repoSpy = AuthRepositorySpy()
        await repoSpy.setLoginResult(.success(expectedResponse))

        let storageSpy = TokenStorageSpy()

        let sut = makeLoginSUT(repo: repoSpy, storage: storageSpy)

        let response = try await sut.execute(
            LoginCommand(
                username: "valid_user",
                password: "pwd"
            )
        )

        #expect(response == expectedResponse)

        let repoCalls = await repoSpy.getLoginCallCount()
        #expect(repoCalls == 1)

        #expect(storageSpy.getSaveCallCount() == 1)
        #expect(storageSpy.getSavedToken() == "success_token")
    }

    @Test("Login validation halts execution on empty fields", arguments: [
        ("", "password123"),
        ("johndoe", ""),
        ("", "")
    ])
    func loginValidationFails(username: String, password: String) async {

        let repoSpy = AuthRepositorySpy()
        let storageSpy = TokenStorageSpy()

        let sut = makeLoginSUT(repo: repoSpy, storage: storageSpy)

        await #expect(throws: AuthValidationError.emptyCredentials) {
            try await sut.execute(
                LoginCommand(
                    username: username,
                    password: password
                )
            )
        }

        let repoCalls = await repoSpy.getLoginCallCount()
        #expect(repoCalls == 0)

        #expect(storageSpy.getSaveCallCount() == 0)
    }

    // MARK: - Register Tests

    @Test("Register orchestrates repository and storage correctly")
    func registerSuccess() async throws {

        let expectedUser = User(
            id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440222")!,
            username: "new_student",
            displayName: "Student"
        )

        let expectedResponse = AuthResponse(
            token: "register_token",
            user: expectedUser
        )

        let repoSpy = AuthRepositorySpy()
        await repoSpy.setRegisterResult(.success(expectedResponse))

        let storageSpy = TokenStorageSpy()

        let sut = makeRegisterSUT(repo: repoSpy, storage: storageSpy)

        let response = try await sut.execute(
            RegisterCommand(
                username: "new_student",
                password: "securePassword123",
                displayName: "Student"
            )
        )

        #expect(response == expectedResponse)

        let repoCalls = await repoSpy.getRegisterCallCount()
        #expect(repoCalls == 1)

        #expect(storageSpy.getSaveCallCount() == 1)
        #expect(storageSpy.getSavedToken() == "register_token")
    }

    @Test("Register validation halts execution on invalid constraints", arguments: [
        ("ab", "password123"),
        ("valid_user", "123")
    ])
    func registerValidationFails(invalidUser: String, invalidPass: String) async {

        let repoSpy = AuthRepositorySpy()
        let storageSpy = TokenStorageSpy()

        let sut = makeRegisterSUT(repo: repoSpy, storage: storageSpy)

        let isUserInvalid = invalidUser.count < 3

        if isUserInvalid {

            await #expect(throws: AuthValidationError.usernameInvalidLength(min: 3, max: 50)) {
                try await sut.execute(
                    RegisterCommand(
                        username: invalidUser,
                        password: invalidPass,
                        displayName: nil
                    )
                )
            }

        } else {

            await #expect(throws: AuthValidationError.passwordInvalidLength(min: 6, max: 128)) {
                try await sut.execute(
                    RegisterCommand(
                        username: invalidUser,
                        password: invalidPass,
                        displayName: nil
                    )
                )
            }
        }

        let repoCalls = await repoSpy.getRegisterCallCount()
        #expect(repoCalls == 0)

        #expect(storageSpy.getSaveCallCount() == 0)
    }

    // MARK: - GetMe Tests

    @Test("GetMe delegates to repository successfully")
    func getMeSuccess() async throws {

        let expectedUser = User(
            id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440333")!,
            username: "current_user",
            displayName: "Current User"
        )

        let repoSpy = AuthRepositorySpy()
        await repoSpy.setGetMeResult(.success(expectedUser))

        let sut = makeGetMeSUT(repo: repoSpy)

        let result = try await sut.execute()

        #expect(result == expectedUser)

        let repoCalls = await repoSpy.getGetMeCallCount()
        #expect(repoCalls == 1)
    }

    @Test("GetMe propagates unauthorized errors")
    func getMePropagatesError() async {

        let repoSpy = AuthRepositorySpy()
        await repoSpy.setGetMeResult(.failure(APIError.unauthorized))

        let sut = makeGetMeSUT(repo: repoSpy)

        await #expect(throws: APIError.unauthorized) {
            _ = try await sut.execute()
        }
    }
}
