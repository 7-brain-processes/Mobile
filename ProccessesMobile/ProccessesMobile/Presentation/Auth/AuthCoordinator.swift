//
//  AuthCoordinator.swift
//  ProccessesMobile
//
//  Created by dark type on 13.03.2026.
//

import Combine

@MainActor
final class AuthCoordinator: ObservableObject, CoordinatorProtocol, AuthNavigating {
    @Published var path: [AuthRoute] = []

    func start() {
        path = []
    }

    func openRegister() {
        path.append(.register)
    }

    func goBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
}
