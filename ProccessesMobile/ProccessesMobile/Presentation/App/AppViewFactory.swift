//
//  AppViewFactory.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//

import SwiftUI
import Foundation

@MainActor
protocol AppViewFactory {
    func makeLoginView(authCoordinator: AuthCoordinator) -> AnyView
    func makeRegisterView(authCoordinator: AuthCoordinator) -> AnyView

    func makeCoursesView(coordinator: CoursesCoordinator) -> AnyView
    func makeCreateCourseView(coordinator: CoursesCoordinator) -> AnyView
    func makeJoinByCodeView(coordinator: CoursesCoordinator) -> AnyView

    func makeCourseFlowView(
        coursesCoordinator: CoursesCoordinator,
        courseId: UUID,
        role: CourseRole
    ) -> AnyView

    func makeFeedView(
        courseId: UUID,
        role: CourseRole,
        navigator: any FeedScreenNavigating
    ) -> AnyView

    func makeTasksView(
        courseId: UUID,
        role: CourseRole,
        navigator: any FeedScreenNavigating
    ) -> AnyView

    func makePeopleView(
        courseId: UUID,
        role: CourseRole
    ) -> AnyView

    func makeTaskDetailView(
        courseId: UUID,
        postId: UUID,
        role: CourseRole
    ) -> AnyView
    func makeMaterialDetailView(
        courseId: UUID,
        postId: UUID,
        role: CourseRole
    ) -> AnyView
    func makeCreatePostView(courseId: UUID, postType: FeedPostType) -> AnyView

    func makeMembersView(courseId: UUID, coordinator: MembersCoordinator) -> AnyView

    // MARK: - New
    func makeCourseCategoriesView(courseId: UUID, role: CourseRole) -> AnyView
    func makeCreateCourseCategoryView(
        courseId: UUID,
        onCreated: @escaping @MainActor () async -> Void
    ) -> AnyView

    func makeCreateTeamRequirementTemplateView(
        courseId: UUID,
        onCreated: @escaping @MainActor (TeamRequirementTemplate) async -> Void
    ) -> AnyView
}
