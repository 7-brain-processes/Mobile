//
//  RegisterViewModel.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//

import Combine

@MainActor
final class RegisterViewModel: ObservableObject {
    private weak var authNavigator: AuthNavigating?
    private weak var appRouter: AppFlowRouting?

    @Published var displayedName: String = ""
    @Published var login: String = ""
    @Published var password: String = ""

    init(
        authNavigator: AuthNavigating,
        appRouter: AppFlowRouting
    ) {
        self.authNavigator = authNavigator
        self.appRouter = appRouter
    }

    func backTapped() {
        authNavigator?.goBack()
    }

    func simulateRegisterSuccessTapped() {
        appRouter?.showMain()
    }
}
