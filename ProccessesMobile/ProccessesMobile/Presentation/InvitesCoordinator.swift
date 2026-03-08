////
////  InvitesCoordinator.swift
////  ProccessesMobile
////
////  Created by Tark Wight on 07.03.2026.
////
//
//import Combine
//import Foundation
//
//enum InvitesSheet: Identifiable, Equatable {
//    case createInvite(UUID)
//
//    var id: String {
//        switch self {
//        case let .createInvite(courseId):
//            return "createInvite-\(courseId)"
//        }
//    }
//}
//
//@MainActor
//final class InvitesCoordinator: ObservableObject, CoordinatorProtocol {
//    let courseId: UUID
//    @Published var sheet: InvitesSheet?
//
//    init(courseId: UUID) {
//        self.courseId = courseId
//    }
//
//    func start() {
//        sheet = nil
//    }
//
//    func openCreateInvite(as role: CourseRole) {
//        guard role == .teacher else { return }
//        sheet = .createInvite(courseId)
//    }
//
//    func dismissSheet() {
//        sheet = nil
//    }
//}
