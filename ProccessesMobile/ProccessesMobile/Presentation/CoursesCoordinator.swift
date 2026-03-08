////
////  CoursesCoordinator.swift
////  ProccessesMobile
////
////  Created by Tark Wight on 07.03.2026.
////
//
//import Combine
//import Foundation
//
//enum MainRoute: Hashable {
//    case course(UUID)
//}
//
//enum MainSheet: Identifiable, Equatable {
//    case createCourse
//    case joinByCode
//
//    var id: String {
//        switch self {
//        case .createCourse: return "createCourse"
//        case .joinByCode: return "joinByCode"
//        }
//    }
//}
//
//@MainActor
//final class CoursesCoordinator: ObservableObject, CoordinatorProtocol {
//    @Published var path: [MainRoute] = []
//    @Published var sheet: MainSheet?
//
//    func start() {
//        path = []
//        sheet = nil
//    }
//
//    func openCreateCourse() {
//        sheet = .createCourse
//    }
//
//    func openJoinByCode() {
//        sheet = .joinByCode
//    }
//
//    func dismissSheet() {
//        sheet = nil
//    }
//
//    func openCourse(id: UUID) {
//        path.append(.course(id))
//    }
//}
