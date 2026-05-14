//
//  AppContainer+AppViewModelFactory.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//

import Foundation

@MainActor
extension AppContainer: ViewModelFactory {
    func makeLoginViewModel(authCoordinator: AuthCoordinator) -> LoginViewModel {
        return LoginViewModel(
            loginUseCase: loginUseCase,
            authNavigator: authCoordinator,
            appRouter: appCoordinator
        )
    }
    
    func makeRegisterViewModel(authCoordinator: AuthCoordinator) -> RegisterViewModel {
        return RegisterViewModel(
            registerUseCase: registerUseCase,
            authNavigator: authCoordinator,
            appRouter: appCoordinator
        )
    }
    
    func makeCoursesViewModel(coordinator: CoursesCoordinator) -> CoursesViewModel {
        return CoursesViewModel(
            getMeUseCase: getMeUseCase,
            getMyCoursesUseCase: getMyCoursesUseCase,
            navigator: coordinator,
            appRouter: appCoordinator
        )
    }
    
    func makeCreateCourseViewModel(coordinator: CoursesCoordinator) -> CreateCourseViewModel {
        CreateCourseViewModel(
            createCourseUseCase: createCourseUseCase,
            navigator: coordinator
        )
    }
    
    func makeJoinByCodeViewModel(coordinator: CoursesCoordinator) -> JoinByCodeViewModel {
        JoinByCodeViewModel(
            joinCourseUseCase: joinCourseUseCase,
            navigator: coordinator
        )
    }
    
    func makeCourseViewModel(courseId: UUID) -> CourseViewModel {
        CourseViewModel(courseId: courseId, role: .teacher)
    }

    func makeFeedViewModel(
        courseId: UUID,
        role: CourseRole,
        navigator: any FeedScreenNavigating
    ) -> FeedViewModel {
        FeedViewModel(
            courseId: courseId,
            role: role,
            listPostsUseCase: listPostsUseCase,
            navigator: navigator
        )
    }

    func makeCreatePostViewModel(
        courseId: UUID,
        initialType: FeedPostType
    ) -> CreatePostViewModel {
        let useCase = DefaultCreatePostUseCase(
            repository: postRepository
        )

        return CreatePostViewModel(
            courseId: courseId,
            initialType: initialType,
            createPostUseCase: useCase,
            listTeamRequirementTemplatesUseCase: listTeamRequirementTemplatesUseCase
        )
    }

    func makeTasksViewModel(
        courseId: UUID,
        role: CourseRole,
        navigator: any FeedScreenNavigating
    ) -> TasksViewModel {
        TasksViewModel(
            courseId: courseId,
            role: role,
            listPostsUseCase: listPostsUseCase,
            navigator: navigator
        )
    }
    
    func makePeopleViewModel(
        courseId: UUID,
        role: CourseRole
    ) -> PeopleViewModel {
        PeopleViewModel(
            courseId: courseId,
            role: role,
            courseMembersRepository: courseMembersRepository,
            createInviteUseCase: createInviteUseCase,
            removeMemberUseCase: removeMemberUseCase
        )
    }

    func makeCourseCoordinator(courseId: UUID) -> CourseCoordinator {
        CourseCoordinator(
            courseId: courseId,
            tasksCoordinator: TasksCoordinator(courseId: courseId),
            peopleCoordinator: PeopleCoordinator(courseId: courseId)
        )
    }
    
    func makeTaskDetailViewModel(
        courseId: UUID,
        postId: UUID,
        role: CourseRole
    ) -> TaskDetailViewModel {
        TaskDetailViewModel(
            courseId: courseId,
            postId: postId,
            role: role,
            getPostUseCase: getPostUseCase
        )
    }
    
    func makeMaterialDetailViewModel(postId: UUID) -> MaterialDetailViewModel {
        MaterialDetailViewModel(
            item: MaterialDetailItem(
                id: postId,
                title: "Lecture slides",
                content: "Review these images before the next lesson.",
                createdAt: Date(),
                authorDisplayName: "Professor Adams",
                attachments: [
                    FeedAttachmentItem(id: UUID(), type: .image, fileName: "slides-1.png", previewURL: nil),
                    FeedAttachmentItem(id: UUID(), type: .image, fileName: "slides-2.png", previewURL: nil)
                ],
                comments: [
                    PostCommentItem(
                        id: UUID(),
                        authorName: "Bob Green",
                        text: "Will this be on the quiz?",
                        createdAt: Date()
                    ),
                    PostCommentItem(
                        id: UUID(),
                        authorName: "Professor Adams",
                        text: "Yes, review these carefully.",
                        createdAt: Date()
                    )
                ]
            )
        )
    }

    // MARK: - NEW
    func makeCourseCategoriesViewModel(courseId: UUID) -> CourseCategoriesViewModel {
        CourseCategoriesViewModel(
            courseId: courseId,
            listCourseCategoriesUseCase: listCourseCategoriesUseCase,
            deleteCourseCategoryUseCase: deleteCourseCategoryUseCase,
            getMyCourseCategoryUseCase: getMyCourseCategoryUseCase,
            setMyCourseCategoryUseCase: setMyCourseCategoryUseCase
        )
    }

    func makeCreateCourseCategoryViewModel(
        courseId: UUID,
        onCreated: @escaping @MainActor () async -> Void
    ) -> CreateCourseCategorySheetViewModel {
        CreateCourseCategorySheetViewModel(
            courseId: courseId,
            createCourseCategoryUseCase: createCourseCategoryUseCase,
            onCreated: onCreated
        )
    }

    func makeEditCourseCategorySheetViewModel(
        courseId: UUID,
        category: CourseCategory,
        onUpdated: @escaping @MainActor () async -> Void
    ) -> EditCourseCategorySheetViewModel {
        EditCourseCategorySheetViewModel(
            courseId: courseId,
            category: category,
            updateCourseCategoryUseCase: updateCourseCategoryUseCase,
            onUpdated: onUpdated
        )
    }

    func makeCreateTeamRequirementTemplateViewModel(
        courseId: UUID,
        onCreated: @escaping @MainActor (TeamRequirementTemplate) async -> Void
    ) -> CreateTeamRequirementTemplateSheetViewModel {
        CreateTeamRequirementTemplateSheetViewModel(
            courseId: courseId,
            listCourseCategoriesUseCase: listCourseCategoriesUseCase,
            createTeamRequirementTemplateUseCase: createTeamRequirementTemplateUseCase,
            onCreated: onCreated
        )
    }
}
