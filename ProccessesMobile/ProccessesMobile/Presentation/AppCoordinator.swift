////
////  AppCoordinator.swift
////  ProccessesMobile
////
////  Created by Tark Wight on 07.03.2026.
////
//
//import Combine
//
//enum AppFlow: Equatable {
//    case auth
//    case main
//}
//
//@MainActor
//final class AppCoordinator: ObservableObject, CoordinatorProtocol {
//    @Published private(set) var flow: AppFlow
//
//    init(isAuthorized: Bool) {
//        self.flow = isAuthorized ? .main : .auth
//    }
//
//    func start() {}
//
//    func showAuth() {
//        flow = .auth
//    }
//
//    func showMain() {
//        flow = .main
//    }
//}
