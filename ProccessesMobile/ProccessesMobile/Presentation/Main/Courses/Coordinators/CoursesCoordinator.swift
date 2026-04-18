//
//  CoursesCoordinator.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

import Combine
import Foundation

@MainActor
final class CoursesCoordinator: ObservableObject, CoordinatorProtocol, CoursesNavigating {
    @Published var path: [MainRoute] = []
    @Published var sheet: MainSheet?

    private var courseCoordinators: [UUID: CourseCoordinator] = [:]

    func start() {
        path = []
        sheet = nil
    }

    func openCreateCourse() {
        sheet = .createCourse
    }

    func openJoinByCode() {
        sheet = .joinByCode
    }

    func dismissSheet() {
        sheet = nil
    }

    func openCourse(id: UUID) {
        path.append(.course(courseId: id))
    }

    func coordinator(
        for id: UUID,
        make: (UUID) -> CourseCoordinator
    ) -> CourseCoordinator {
        if let existing = courseCoordinators[id] {
            return existing
        }

        let coordinator = make(id)
        courseCoordinators[id] = coordinator
        return coordinator
    }
}
extension CoursesCoordinator: FeedScreenNavigating {
    func openTaskDetail(courseId: UUID, postId: UUID) {
        path.append(.taskDetails(courseId: courseId, postId: postId))
       }

       func openMaterialDetail(courseId: UUID, postId: UUID) {
           path.append(.materialDetails(courseId: courseId, postId: postId))
       }

       func openCreatePost(courseId: UUID, type: FeedPostType) {
           path.append(.createPost(courseId, type))
       }
}

@MainActor
extension CoursesCoordinator {
    func showCourseCategories(courseId: UUID) {
        path.append(.courseCategories(courseId: courseId))
    }
}
