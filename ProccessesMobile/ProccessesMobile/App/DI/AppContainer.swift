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

    init(isAuthorized: Bool) {
        self.appCoordinator = AppCoordinator(isAuthorized: isAuthorized)
        self.authCoordinator = AuthCoordinator()
        self.coursesCoordinator = CoursesCoordinator()
    }
}

