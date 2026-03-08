////
////  AuthCoordinator.swift
////  ProccessesMobile
////
////  Created by Tark Wight on 07.03.2026.
////
//
//import  Combine
//
//enum AuthRoute: Hashable {
//    case register
//}
//
//@MainActor
//final class AuthCoordinator: ObservableObject, CoordinatorProtocol {
//    @Published var path: [AuthRoute] = []
//
//    func start() {
//        path = []
//    }
//
//    func openRegister() {
//        path.append(.register)
//    }
//
//    func goBack() {
//        guard !path.isEmpty else { return }
//        path.removeLast()
//    }
//}
