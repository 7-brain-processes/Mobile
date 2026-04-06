//
//  AuthRepositorySpy.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

actor AuthRepositorySpy: AuthRepository {

    // MARK: - Call counters

    private var loginCallCount = 0
    private var registerCallCount = 0
    private var getMeCallCount = 0


    // MARK: - Results

    private var loginResult: Result<AuthResponse, Error> =
        .failure(APIError.unauthorized)

    private var registerResult: Result<AuthResponse, Error> =
        .failure(APIError.invalidResponse)

    private var getMeResult: Result<User, Error> =
        .failure(APIError.unauthorized)


    // MARK: - Configure results

    func setLoginResult(_ result: Result<AuthResponse, Error>) {
        loginResult = result
    }

    func setRegisterResult(_ result: Result<AuthResponse, Error>) {
        registerResult = result
    }

    func setGetMeResult(_ result: Result<User, Error>) {
        getMeResult = result
    }


    // MARK: - Inspect calls

    func getLoginCallCount() -> Int {
        loginCallCount
    }

    func getRegisterCallCount() -> Int {
        registerCallCount
    }

    func getGetMeCallCount() -> Int {
        getMeCallCount
    }


    // MARK: - Repository methods

    func login(request: LoginCommand) async throws -> AuthResponse {
        loginCallCount += 1
        return try loginResult.get()
    }

    func register(request: RegisterCommand) async throws -> AuthResponse {
        registerCallCount += 1
        return try registerResult.get()
    }

    func getMe() async throws -> User {
        getMeCallCount += 1
        return try getMeResult.get()
    }
}
