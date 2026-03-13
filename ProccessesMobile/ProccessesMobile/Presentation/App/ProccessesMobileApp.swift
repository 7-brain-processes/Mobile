//
//  ProccessesMobileApp.swift
//  ProccessesMobile
//
//  Created by dark type on 13.03.2026.
//

import SwiftUI

@main
struct ProccessesMobileApp: App {
    @StateObject private var container = AppContainer(isAuthorized: false)

    var body: some Scene {
        WindowGroup {
            AppRootView(
                container: container,
                appCoordinator: container.appCoordinator,
                factory: container
            )
        }
    }
}
