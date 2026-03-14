//
//  LoginViewModel.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//

import Combine
import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    private let loginUseCase: LoginUseCase
    private weak var authNavigator: AuthNavigating?
    private weak var appRouter: AppFlowRouting?

    @Published var login: String = ""
    @Published var password: String = ""

    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    init(
        loginUseCase: LoginUseCase,
        authNavigator: AuthNavigating,
        appRouter: AppFlowRouting
    ) {
        self.loginUseCase = loginUseCase
        self.authNavigator = authNavigator
        self.appRouter = appRouter
    }

    func registerTapped() {
        authNavigator?.openRegister()
    }

    func loginTapped() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            _ = try await loginUseCase.execute(
                LoginCommand(
                    username: login.trimmingCharacters(in: .whitespacesAndNewlines),
                    password: password
                )
            )

            appRouter?.showMain()
        } catch let error as AuthValidationError {
            errorMessage = mapValidationError(error)
        } catch let error as APIError {
            errorMessage = mapAPIError(error)
        } catch {
            errorMessage = "Unexpected error"
        }
    }

    private func mapValidationError(_ error: AuthValidationError) -> String {
        switch error {
        case .emptyCredentials:
            return "Введите логин и пароль"
        case .usernameInvalidLength(min: let min, max: let max):
            return "Некорректная длина имени"
        case .passwordInvalidLength(min: let min, max: let max):
            return "Слишкои короткий пароль"
        }
    }

    private func mapAPIError(_ error: APIError) -> String {
        switch error {
        case .unauthorized:
            return "Неверный логин или пароль"
        case .serverError(let code):
            return "Ошибка сервера: \(code)"
        case .invalidResponse:
            return "Некорректный ответ сервера"
        case .underlying:
            return "Ошибка сети"
        case .invalidURL:
            return "Ошибка в URL"
        }
    }
}
