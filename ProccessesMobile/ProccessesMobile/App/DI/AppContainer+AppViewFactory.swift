//
//  AppContainer+AppViewFactory.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//

import SwiftUI
import Foundation

@MainActor
extension AppContainer: AppViewFactory {
    func makeLoginView(authCoordinator: AuthCoordinator) -> AnyView {
        AnyView(
            LoginView(
                viewModel: self.makeLoginViewModel(authCoordinator: authCoordinator)
            )
        )
    }

    func makeRegisterView(authCoordinator: AuthCoordinator) -> AnyView {
        AnyView(
            RegisterView(
                viewModel: self.makeRegisterViewModel(authCoordinator: authCoordinator)
            )
        )
    }

    func makeCoursesView(coordinator: CoursesCoordinator) -> AnyView {
        AnyView(
            CoursesView(
                viewModel: self.makeCoursesViewModel(coordinator: coordinator)
            )
        )
    }

    func makeCreateCourseView(coordinator: CoursesCoordinator) -> AnyView {
        AnyView(
            CreateCourseView(
                viewModel: self.makeCreateCourseViewModel(coordinator: coordinator)
            )
        )
    }

    func makeJoinByCodeView(coordinator: CoursesCoordinator) -> AnyView {
        AnyView(
            JoinByCodeView(
                viewModel: self.makeJoinByCodeViewModel(coordinator: coordinator)
            )
        )
    }

    func makeCourseFlowView(
        coursesCoordinator: CoursesCoordinator,
        courseId: UUID,
        role: CourseRole
    ) -> AnyView {
        let coordinator = coursesCoordinator.coordinator(for: courseId) { id in
            makeCourseCoordinator(courseId: id)
        }

        return AnyView(
            CourseFlowView(
                coordinator: coordinator,
                coursesCoordinator: coursesCoordinator,
                factory: self,
                role: role
            )
        )
    }
    func makeFeedView(
        courseId: UUID,
        role: CourseRole,
        navigator: any FeedScreenNavigating
    ) -> AnyView {
        AnyView(
            FeedView(
                viewModel: makeFeedViewModel(
                    courseId: courseId,
                    role: role,
                    navigator: navigator
                )
            )
        )
    }

    func makeTasksView(
        courseId: UUID,
        role: CourseRole,
        navigator: any FeedScreenNavigating
    ) -> AnyView {
        AnyView(
            TasksView(
                viewModel: makeTasksViewModel(
                    courseId: courseId,
                    role: role,
                    navigator: navigator
                )
            )
        )
    }

    func makePeopleView(
        courseId: UUID,
        role: CourseRole
    ) -> AnyView {
        AnyView(
            PeopleView(
                viewModel: makePeopleViewModel(
                    courseId: courseId,
                    role: role
                )
            )
        )
    }

    func makeTaskDetailView(
        courseId: UUID,
        postId: UUID,
        role: CourseRole
    ) -> AnyView {
        AnyView(
            TaskDetailView(
                viewModel: makeTaskDetailViewModel(
                    courseId: courseId,
                    postId: postId,
                    role: role
                )
            )
        )
    }

    func makeMaterialDetailView(courseId: UUID, postId: UUID, role: CourseRole) -> AnyView {
        AnyView(
            MaterialDetailView(
                viewModel: makeMaterialDetailViewModel(postId: postId)
            )
        )
    }

    func makeCreatePostView(
        courseId: UUID,
        postType initialType: FeedPostType
    ) -> AnyView {
        let viewModel = makeCreatePostViewModel(
            courseId: courseId,
            initialType: initialType
        )

        return AnyView(
            CreatePostView(
                viewModel: viewModel,
                createTemplateViewBuilder: {
                    AnyView(
                        CreateTeamRequirementTemplateSheetView(
                            viewModel: self.makeCreateTeamRequirementTemplateViewModel(
                                courseId: courseId,
                                onCreated: { template in
                                    await viewModel.handleTemplateCreated(template)
                                }
                            )
                        )
                    )
                }
            )
        )
    }

    func makeMembersView(courseId: UUID, coordinator: MembersCoordinator) -> AnyView {
        AnyView(Text("Members View"))
    }

    func makeCourseCategoriesView(courseId: UUID, role: CourseRole) -> AnyView {
        let listViewModel = makeCourseCategoriesViewModel(courseId: courseId)

        return AnyView(
            CourseCategoriesView(
                viewModel: listViewModel,
                role: role,
                createViewBuilder: {
                    AnyView(
                        CreateCourseCategorySheetView(
                            viewModel: self.makeCreateCourseCategoryViewModel(
                                courseId: courseId,
                                onCreated: {
                                    await listViewModel.handleCategoryCreated()
                                }
                            )
                        )
                    )
                },
                editViewBuilder: { category in
                    AnyView(
                        EditCourseCategorySheetView(
                            viewModel: self.makeEditCourseCategorySheetViewModel(
                                courseId: courseId,
                                category: category,
                                onUpdated: {
                                    await listViewModel.handleCategoryUpdated()
                                }
                            )
                        )
                    )
                }
            )
        )
    }

    func makeCreateCourseCategoryView(
        courseId: UUID,
        onCreated: @escaping @MainActor () async -> Void
    ) -> AnyView {
        AnyView(
            CreateCourseCategorySheetView(
                viewModel: self.makeCreateCourseCategoryViewModel(
                    courseId: courseId,
                    onCreated: onCreated
                )
            )
        )
    }

    func makeCreateTeamRequirementTemplateView(
        courseId: UUID,
        onCreated: @escaping @MainActor (TeamRequirementTemplate) async -> Void
    ) -> AnyView {
        AnyView(
            CreateTeamRequirementTemplateSheetView(
                viewModel: self.makeCreateTeamRequirementTemplateViewModel(
                    courseId: courseId,
                    onCreated: onCreated
                )
            )
        )
    }
}
