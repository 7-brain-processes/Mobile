//
//  AuthRepositorySpy.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

actor AuthRepositorySpy: AuthRepository {
    private var loginCallCount = 0
    private var registerCallCount = 0
    private var getMeCallCount = 0
    
    private var loginResult: Result<AuthResponse, Error> = .failure(APIError.unauthorized)
    private var registerResult: Result<AuthResponse, Error> = .failure(APIError.invalidResponse)
    private var getMeResult: Result<User, Error> = .failure(APIError.unauthorized)
    
    func setLoginResult(_ result: Result<AuthResponse, Error>) { self.loginResult = result }
    func setRegisterResult(_ result: Result<AuthResponse, Error>) { self.registerResult = result }
    func setGetMeResult(_ result: Result<User, Error>) { self.getMeResult = result }
    
    func getLoginCallCount() -> Int { return loginCallCount }
    func getRegisterCallCount() -> Int { return registerCallCount }
    func getGetMeCallCount() -> Int { return getMeCallCount }
    
    func login(request: LoginRequest) async throws -> AuthResponse {
        loginCallCount += 1
        return try loginResult.get()
    }
    
    func register(request: RegisterRequest) async throws -> AuthResponse {
        registerCallCount += 1
        return try registerResult.get()
    }
    
    func getMe() async throws -> User {
        getMeCallCount += 1
        return try getMeResult.get()
    }
}
