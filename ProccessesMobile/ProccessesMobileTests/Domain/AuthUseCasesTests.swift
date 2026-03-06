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
    
    func makeLoginSUT(repo: AuthRepository, storage: TokenStorage) -> LoginUseCase {
        return FakeLoginUseCase(repository: repo, tokenStorage: storage)
    }

    func makeRegisterSUT(repo: AuthRepository, storage: TokenStorage) -> RegisterUseCase {
        return FakeRegisterUseCase(repository: repo, tokenStorage: storage)
    }
    func makeGetMeSUT(repo: AuthRepository) -> GetMeUseCase {
            return MockGetMeUseCase(repository: repo)
        }
    
    // MARK: - Login Tests
    
    @Test("Login orchestrates repository and storage correctly")
    func loginSuccess() async throws {
        let expectedUser = User(id: "1", username: "valid_user", displayName: nil)
        let expectedResponse = AuthResponse(token: "success_token", user: expectedUser)
        
        let repoSpy = AuthRepositorySpy()
        await repoSpy.setLoginResult(.success(expectedResponse))
        
        let storageSpy = TokenStorageSpy()
        
        let sut = makeLoginSUT(repo: repoSpy, storage: storageSpy)
        let request = LoginRequest(username: "valid_user", password: "pwd")
        
        let response = try await sut.execute(request: request)
        
        #expect(response == expectedResponse)
        
        // Using explicit functions!
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
            try await sut.execute(request: LoginRequest(username: username, password: password))
        }
        
        let repoCalls = await repoSpy.getLoginCallCount()
        #expect(repoCalls == 0)
        #expect(storageSpy.getSaveCallCount() == 0)
    }
    
    // MARK: - Register Tests
    
    @Test("Register orchestrates repository and storage correctly")
    func registerSuccess() async throws {
        let expectedUser = User(id: "2", username: "new_student", displayName: "Student")
        let expectedResponse = AuthResponse(token: "register_token", user: expectedUser)
        
        let repoSpy = AuthRepositorySpy()
        await repoSpy.setRegisterResult(.success(expectedResponse))
        let storageSpy = TokenStorageSpy()
        
        let sut = makeRegisterSUT(repo: repoSpy, storage: storageSpy)
        let request = RegisterRequest(username: "new_student", password: "securePassword123", displayName: "Student")
        
        let response = try await sut.execute(request: request)
        
        #expect(response == expectedResponse)
        
        let repoCalls = await repoSpy.getRegisterCallCount()
        #expect(repoCalls == 1)
        #expect(storageSpy.getSaveCallCount() == 1)
        #expect(storageSpy.getSavedToken() == "register_token")
    }
    
    @Test("Register validation halts execution on invalid constraints", arguments: [
        ("ab", "password123"), // Username too short
        ("valid_user", "123")  // Password too short
    ])
    func registerValidationFails(invalidUser: String, invalidPass: String) async {
        let repoSpy = AuthRepositorySpy()
        let storageSpy = TokenStorageSpy()
        let sut = makeRegisterSUT(repo: repoSpy, storage: storageSpy)
        
        let isUserInvalid = invalidUser.count < 3
        
        if isUserInvalid {
            await #expect(throws: AuthValidationError.usernameInvalidLength(min: 3, max: 50)) {
                try await sut.execute(request: RegisterRequest(username: invalidUser, password: invalidPass))
            }
        } else {
            await #expect(throws: AuthValidationError.passwordInvalidLength(min: 6, max: 128)) {
                try await sut.execute(request: RegisterRequest(username: invalidUser, password: invalidPass))
            }
        }
        
        let repoCalls = await repoSpy.getRegisterCallCount()
        #expect(repoCalls == 0)
        #expect(storageSpy.getSaveCallCount() == 0)
    }
    @Test("GetMe delegates to repository successfully")
     func getMeSuccess() async throws {
         let expectedUser = User(id: "123", username: "current_user", displayName: "Current User")
         
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
