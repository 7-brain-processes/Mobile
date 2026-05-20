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
            getPostUseCase: getPostUseCase,
            listPostMaterialsUseCase: listPostMaterialsUseCase,
            uploadPostMaterialUseCase: uploadPostMaterialUseCase,
            downloadPostMaterialUseCase: downloadPostMaterialUseCase,
            deletePostMaterialUseCase: deletePostMaterialUseCase,
            listPostCommentsUseCase: listPostCommentsUseCase,
            createPostCommentUseCase: createPostCommentUseCase,
            getMySolutionUseCase: getMySolutionUseCase,
            submitSolutionUseCase: submitSolutionUseCase,
            listSolutionsUseCase: listSolutionsUseCase,
            gradeSolutionUseCase: gradeSolutionUseCase,
            listSolutionFilesUseCase: listSolutionFilesUseCase,
            uploadSolutionFileUseCase: uploadSolutionFileUseCase,
            deleteSolutionFileUseCase: deleteSolutionFileUseCase,
            downloadSolutionFileUseCase: downloadSolutionFileUseCase,
            listTeamRequirementTemplatesUseCase: listTeamRequirementTemplatesUseCase,
            createPostTeamUseCase: createPostTeamUseCase,
            updateTeamGradeUseCase: updateTeamGradeUseCase,
            listTeamsForEnrollmentUseCase: listTeamsForEnrollmentUseCase,
            getMyTeamInPostUseCase: getMyTeamInPostUseCase,
            enrollStudentInTeamUseCase: enrollStudentInTeamUseCase,
            leaveTeamUseCase: leaveTeamUseCase,
            listCourseTeamsUseCase: listCourseTeamsUseCase,
            getTeamGradeUseCase: getTeamGradeUseCase,
            getTeamGradeDistributionUseCase: getTeamGradeDistributionUseCase,
            updateTeamGradeDistributionUseCase: updateTeamGradeDistributionUseCase
        )
    }

    func makeMaterialDetailViewModel(
        courseId: UUID,
        postId: UUID,
        role: CourseRole
    ) -> MaterialDetailViewModel {
        MaterialDetailViewModel(
            courseId: courseId,
            postId: postId,
            role: role,
            getPostUseCase: getPostUseCase,
            listPostMaterialsUseCase: listPostMaterialsUseCase,
            uploadPostMaterialUseCase: uploadPostMaterialUseCase,
            downloadPostMaterialUseCase: downloadPostMaterialUseCase,
            deletePostMaterialUseCase: deletePostMaterialUseCase,
            listPostCommentsUseCase: listPostCommentsUseCase,
            createPostCommentUseCase: createPostCommentUseCase
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
