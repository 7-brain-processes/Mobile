//
//  AppContainer.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//


import Foundation
import Combine
import SwiftUI

@MainActor
final class AppContainer: ObservableObject {
    let appCoordinator: AppCoordinator
    let authCoordinator: AuthCoordinator
    let coursesCoordinator: CoursesCoordinator

    let apiConfiguration: APIConfiguration
    let tokenStorage: TokenStorage
    let httpClient: HTTPClient
    let apiClient: APIClient
    let authRepository: AuthRepository

    init(isAuthorized: Bool) {
        self.appCoordinator = AppCoordinator(isAuthorized: isAuthorized)
        self.authCoordinator = AuthCoordinator()
        self.coursesCoordinator = CoursesCoordinator()

        self.apiConfiguration = APIConfiguration(
            baseURL: URL(string: "https://backend.hits-playground.ru/api/v1")!
        )
        self.tokenStorage = KeychainTokenStorage()

        self.httpClient = URLSessionHTTPClient()

        self.apiClient = APIClient(
            httpClient: httpClient,
            configuration: apiConfiguration,
            tokenProvider: tokenStorage
        )

        self.authRepository = DefaultAuthRepository(apiClient: apiClient)
    }
}

