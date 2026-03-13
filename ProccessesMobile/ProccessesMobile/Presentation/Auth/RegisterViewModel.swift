//
//  RegisterViewModel.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//

import Combine
import Foundation

@MainActor
final class RegisterViewModel: ObservableObject {
    private let registerUseCase: RegisterUseCase
    private weak var authNavigator: AuthNavigating?
    private weak var appRouter: AppFlowRouting?

    @Published var displayedName: String = ""
    @Published var login: String = ""
    @Published var password: String = ""

    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    init(
        registerUseCase: RegisterUseCase,
        authNavigator: AuthNavigating,
        appRouter: AppFlowRouting
    ) {
        self.registerUseCase = registerUseCase
        self.authNavigator = authNavigator
        self.appRouter = appRouter
    }

    func backTapped() {
        authNavigator?.goBack()
    }

    func registerTapped() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            _ = try await registerUseCase.execute(
                RegisterCommand(
                    username: login.trimmingCharacters(in: .whitespacesAndNewlines),
                    password: password,
                    displayName: normalizedDisplayName()
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

    private func normalizedDisplayName() -> String? {
        let trimmed = displayedName.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    private func mapValidationError(_ error: AuthValidationError) -> String {
        switch error {
        case .emptyCredentials:
            return "Введите логин и пароль"
        case .usernameInvalidLength(let min, let max):
            return "Логин должен быть от \(min) до \(max) символов"
        case .passwordInvalidLength(let min, let max):
            return "Пароль должен быть от \(min) до \(max) символов"
        }
    }

    private func mapAPIError(_ error: APIError) -> String {
        switch error {
        case .unauthorized:
            return "Ошибка авторизации"
        case .serverError(let code) where code == 409:
            return "Пользователь с таким логином уже существует"
        case .serverError(let code):
            return "Ошибка сервера: \(code)"
        case .invalidResponse:
            return "Некорректный ответ сервера"
        case .underlying:
            return "Ошибка сети"
        case .invalidURL:
            return "Ошибка URL"
        }
    }
}
