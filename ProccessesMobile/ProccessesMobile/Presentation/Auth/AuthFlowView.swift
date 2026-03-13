//
//  AuthFlowView.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//

import SwiftUI
import Combine

struct AuthFlowView: View {
    @ObservedObject var coordinator: AuthCoordinator
    let factory: any AppViewFactory

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            factory.makeLoginView(authCoordinator: coordinator)
                .navigationDestination(for: AuthRoute.self) { route in
                    switch route {
                    case .register:
                        factory.makeRegisterView(authCoordinator: coordinator)
                    }
                }
        }
    }
}
