////
////  InfoCoordinator.swift
////  ProccessesMobile
////
////  Created by Tark Wight on 07.03.2026.
////
//
//import Combine
//import Foundation
//
//enum InfoSheet: Identifiable, Equatable {
//    case editCourse(UUID)
//
//    var id: String {
//        switch self {
//        case let .editCourse(courseId):
//            return "editCourse-\(courseId)"
//        }
//    }
//}
//
//@MainActor
//final class InfoCoordinator: ObservableObject, CoordinatorProtocol {
//    let courseId: UUID
//    @Published var sheet: InfoSheet?
//
//    init(courseId: UUID) {
//        self.courseId = courseId
//    }
//
//    func start() {
//        sheet = nil
//    }
//
//    func openEditCourse(as role: CourseRole) {
//        guard role == .teacher else { return }
//        sheet = .editCourse(courseId)
//    }
//
//    func dismissSheet() {
//        sheet = nil
//    }
//}
