//
//  LoginViewModel.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//

import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    private weak var authNavigator: AuthNavigating?
    private weak var appRouter: AppFlowRouting?

    @Published var login: String = ""
    @Published var password: String = ""

    init(
        authNavigator: AuthNavigating,
        appRouter: AppFlowRouting
    ) {
        self.authNavigator = authNavigator
        self.appRouter = appRouter
    }

    func registerTapped() {
        authNavigator?.openRegister()
    }

    func simulateLoginTapped() {
        appRouter?.showMain()
    }
}
