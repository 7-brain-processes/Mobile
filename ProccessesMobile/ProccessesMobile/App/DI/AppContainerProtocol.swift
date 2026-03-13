//
//  AppContainerProtocol.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//


import Foundation

@MainActor
protocol AppContainerProtocol {
    var appCoordinator: AppCoordinator { get }

    func makeAuthCoordinator() -> AuthCoordinator
}
