//
//  AppRootView.swift
//  ProccessesMobile
//
//  Created by dark type on 13.03.2026.
//


import SwiftUI

struct AppRootView<Factory: AppViewFactory>: View {
    @ObservedObject var container: AppContainer
    @ObservedObject var appCoordinator: AppCoordinator
    let factory: Factory

    var body: some View {
        Group {
            switch appCoordinator.flow {
            case .auth:
                AuthFlowView(
                    coordinator: container.authCoordinator,
                    factory: factory
                )
            case .main:
                MainFlowView(
                    coordinator: container.coursesCoordinator,
                    factory: factory
                )
            }
        }
        .task {
            appCoordinator.start()
            container.authCoordinator.start()
            container.coursesCoordinator.start()
        }
    }
}
