//
//  AppContainer.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//


import Foundation
import Combine
import SwiftUI


@MainActor
final class AppContainer: ObservableObject {
    let appCoordinator: AppCoordinator
    let authCoordinator: AuthCoordinator
    let coursesCoordinator: CoursesCoordinator

    let apiConfiguration: APIConfiguration
    let tokenStorage: TokenStorage
    let httpClient: HTTPClient
    let apiClient: APIClient

    let authRepository: AuthRepository
    let courseRepository: CourseRepository
    let courseDetailsRepository: CourseDetailsRepository
    let courseInvitesRepository: CourseInvitesRepository
    let gradingRepository: GradingRepository
    let courseMembershipRepository: CourseMembershipRepository
    let courseMembersRepository: CourseMembersRepository
    let postCommentsRepository: PostCommentsRepository
    let postMaterialsRepository: PostMaterialsRepository
    let postRepository: PostRepository
    let solutionCommentsRepository: SolutionCommentsRepository
    let solutionFilesRepository: SolutionFilesRepository
    let solutionRepository: SolutionRepository

    let deletePostMaterialUseCase: DeletePostMaterialUseCase
    let downloadPostMaterialUseCase: DownloadPostMaterialUseCase
    let listPostMaterialsUseCase: ListPostMaterialsUseCase
    let uploadPostMaterialUseCase: UploadPostMaterialUseCase

    let getMeUseCase: GetMeUseCase
    let loginUseCase: LoginUseCase
    let registerUseCase: RegisterUseCase

    let createInviteUseCase: CreateInviteUseCase
    let getMyCoursesUseCase: GetMyCoursesUseCase
    let joinCourseUseCase: JoinCourseUseCase
    let leaveCourseUseCase: LeaveCourseUseCase
    let removeMemberUseCase: RemoveMemberUseCase
    let revokeInviteUseCase: RevokeInviteUseCase

    let createCourseUseCase: CreateCourseUseCase
    let deleteCourseUseCase: DeleteCourseUseCase
    let getCourseUseCase: GetCourseUseCase
    let updateCourseUseCase: UpdateCourseUseCase

    let createPostCommentUseCase: CreatePostCommentUseCase
    let createPostUseCase: CreatePostUseCase
    let deletePostUseCase: DeletePostUseCase
    let getPostUseCase: GetPostUseCase
    let listPostsUseCase: ListPostsUseCase
    let updatePostUseCase: UpdatePostUseCase

    let createSolutionCommentUseCase: CreateSolutionCommentUseCase
    let deleteSolutionCommentUseCase: DeleteSolutionCommentUseCase
    let deleteSolutionFileUseCase: DeleteSolutionFileUseCase
    let deleteSolutionUseCase: DeleteSolutionUseCase
    let downloadSolutionFileUseCase: DownloadSolutionFileUseCase
    let getMySolutionUseCase: GetMySolutionUseCase
    let getSolutionUseCase: GetSolutionUseCase
    let gradeSolutionUseCase: GradeSolutionUseCase
    let listSolutionCommentsUseCase: ListSolutionCommentsUseCase
    let listSolutionFilesUseCase: ListSolutionFilesUseCase
    let listSolutionsUseCase: ListSolutionsUseCase
    let submitSolutionUseCase: SubmitSolutionUseCase
    let updateSolutionCommentUseCase: UpdateSolutionCommentUseCase
    let updateSolutionUseCase: UpdateSolutionUseCase
    let uploadSolutionFileUseCase: UploadSolutionFileUseCase

    // MARK: - NEW
    let courseCategoriesRepository: CourseCategoriesRepository
    let listCourseCategoriesUseCase: ListCourseCategoriesUseCase

    let createCourseCategoryUseCase: CreateCourseCategoryUseCase

    init(isAuthorized: Bool) {
        self.appCoordinator = AppCoordinator(isAuthorized: isAuthorized)
        self.authCoordinator = AuthCoordinator()
        self.coursesCoordinator = CoursesCoordinator()

        self.apiConfiguration = APIConfiguration(
            baseURL: URL(string: "https://backend.hits-playground.ru/api/v1")!
        )
        self.tokenStorage = KeychainTokenStorage()
        self.httpClient = URLSessionHTTPClient()

        self.apiClient = APIClient(
            httpClient: httpClient,
            configuration: apiConfiguration,
            tokenProvider: tokenStorage
        )

        self.authRepository = DefaultAuthRepository(apiClient: apiClient)
        self.courseRepository = DefaultCourseRepository(apiClient: apiClient)
        self.courseDetailsRepository = DefaultCourseDetailsRepository(apiClient: apiClient)
        self.courseInvitesRepository = DefaultCourseInvitesRepository(apiClient: apiClient)
        self.gradingRepository = DefaultGradingRepository(apiClient: apiClient)
        self.courseMembershipRepository = DefaultCourseMembershipRepository(apiClient: apiClient)
        self.courseMembersRepository = DefaultCourseMembersRepository(apiClient: apiClient)
        self.postCommentsRepository = DefaultPostCommentsRepository(apiClient: apiClient)
        self.postMaterialsRepository = DefaultPostMaterialsRepository(apiClient: apiClient)
        self.postRepository = DefaultPostRepository(apiClient: apiClient)
        self.solutionCommentsRepository = DefaultSolutionCommentsRepository(apiClient: apiClient)
        self.solutionFilesRepository = DefaultSolutionFilesRepository(apiClient: apiClient)
        self.solutionRepository = DefaultSolutionRepository(apiClient: apiClient)

        self.deletePostMaterialUseCase = DefaultDeletePostMaterialUseCase(
            repository: postMaterialsRepository
        )
        self.downloadPostMaterialUseCase = DefaultDownloadPostMaterialUseCase(
            repository: postMaterialsRepository
        )
        self.listPostMaterialsUseCase = DefaultListPostMaterialsUseCase(
            repository: postMaterialsRepository
        )
        self.uploadPostMaterialUseCase = DefaultUploadPostMaterialUseCase(
            repository: postMaterialsRepository
        )

        self.getMeUseCase = DefaultGetMeUseCase(
            repository: authRepository
        )
        self.loginUseCase = DefaultLoginUseCase(
            repository: authRepository,
            tokenStorage: tokenStorage
        )
        self.registerUseCase = DefaultRegisterUseCase(
            repository: authRepository,
            tokenStorage: tokenStorage
        )

        self.createInviteUseCase = DefaultCreateInviteUseCase(
            repository: courseInvitesRepository
        )
        self.getMyCoursesUseCase = DefaultGetMyCoursesUseCase(
            repository: courseRepository
        )
        self.joinCourseUseCase = DefaultJoinCourseUseCase(
            repository: courseMembershipRepository
        )
        self.leaveCourseUseCase = DefaultLeaveCourseUseCase(
            repository: courseMembershipRepository
        )
        self.removeMemberUseCase = DefaultRemoveMemberUseCase(
            repository: courseMembersRepository
        )
        self.revokeInviteUseCase = DefaultRevokeInviteUseCase(
            repository: courseInvitesRepository
        )

        self.createCourseUseCase = DefaultCreateCourseUseCase(
            repository: courseRepository
        )
        self.deleteCourseUseCase = DefaultDeleteCourseUseCase(
            repository: courseDetailsRepository
        )
        self.getCourseUseCase = DefaultGetCourseUseCase(
            repository: courseDetailsRepository
        )
        self.updateCourseUseCase = DefaultUpdateCourseUseCase(
            repository: courseDetailsRepository
        )

        self.createPostCommentUseCase = DefaultCreatePostCommentUseCase(
            repository: postCommentsRepository
        )
        self.createPostUseCase = DefaultCreatePostUseCase(
            repository: postRepository
        )
        self.deletePostUseCase = DefaultDeletePostUseCase(
            repository: postRepository
        )
        self.getPostUseCase = DefaultGetPostUseCase(
            repository: postRepository
        )
        self.listPostsUseCase = DefaultListPostsUseCase(
            repository: postRepository
        )
        self.updatePostUseCase = DefaultUpdatePostUseCase(
            repository: postRepository
        )

        self.createSolutionCommentUseCase = DefaultCreateSolutionCommentUseCase(
            repository: solutionCommentsRepository
        )
        self.deleteSolutionCommentUseCase = DefaultDeleteSolutionCommentUseCase(
            repository: solutionCommentsRepository
        )
        self.deleteSolutionFileUseCase = DefaultDeleteSolutionFileUseCase(
            repository: solutionFilesRepository
        )
        self.deleteSolutionUseCase = DefaultDeleteSolutionUseCase(
            repository: solutionRepository
        )
        self.downloadSolutionFileUseCase = DefaultDownloadSolutionFileUseCase(
            repository: solutionFilesRepository
        )
        self.getMySolutionUseCase = DefaultGetMySolutionUseCase(
            repository: solutionRepository
        )
        self.getSolutionUseCase = DefaultGetSolutionUseCase(
            repository: solutionRepository
        )
        self.gradeSolutionUseCase = DefaultGradeSolutionUseCase(
            repository: gradingRepository
        )
        self.listSolutionCommentsUseCase = DefaultListSolutionCommentsUseCase(
            repository: solutionCommentsRepository
        )
        self.listSolutionFilesUseCase = DefaultListSolutionFilesUseCase(
            repository: solutionFilesRepository
        )
        self.listSolutionsUseCase = DefaultListSolutionsUseCase(
            repository: solutionRepository
        )
        self.submitSolutionUseCase = DefaultSubmitSolutionUseCase(
            repository: solutionRepository
        )
        self.updateSolutionCommentUseCase = DefaultUpdateSolutionCommentUseCase(
            repository: solutionCommentsRepository
        )
        self.updateSolutionUseCase = DefaultUpdateSolutionUseCase(
            repository: solutionRepository
        )
        self.uploadSolutionFileUseCase = DefaultUploadSolutionFileUseCase(
            repository: solutionFilesRepository
        )

        // MARK: - NEW

        self.courseCategoriesRepository = DefaultCourseCategoriesRepository(
            apiClient: apiClient
        )

        self.listCourseCategoriesUseCase = DefaultListCourseCategoriesUseCase(
            repository: courseCategoriesRepository
        )

        self.createCourseCategoryUseCase = DefaultCreateCourseCategoryUseCase(
            repository: courseCategoriesRepository
        )
    }
}
extension AppContainer: AppContainerDependencyProviding {}
