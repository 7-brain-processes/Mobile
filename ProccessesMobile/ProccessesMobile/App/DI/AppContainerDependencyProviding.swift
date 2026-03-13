//
//  AppContainerDependencyProviding.swift
//  ProccessesMobile
//
//  Created by dark type on 13.03.2026.
//


@MainActor
protocol AppContainerDependencyProviding: AnyObject {
    var appCoordinator: AppCoordinator { get }
    var authCoordinator: AuthCoordinator { get }
    var coursesCoordinator: CoursesCoordinator { get }

    var apiConfiguration: APIConfiguration { get }
    var tokenStorage: TokenStorage { get }
    var httpClient: HTTPClient { get }
    var apiClient: APIClient { get }

    var authRepository: AuthRepository { get }
    var courseRepository: CourseRepository { get }
    var courseDetailsRepository: CourseDetailsRepository { get }
    var courseInvitesRepository: CourseInvitesRepository { get }
    var gradingRepository: GradingRepository { get }
    var courseMembershipRepository: CourseMembershipRepository { get }
    var courseMembersRepository: CourseMembersRepository { get }
    var postRepository: PostRepository { get }
    var postCommentsRepository: PostCommentsRepository { get }
    var postMaterialsRepository: PostMaterialsRepository { get }
    var solutionRepository: SolutionRepository { get }
    var solutionCommentsRepository: SolutionCommentsRepository { get }
    var solutionFilesRepository: SolutionFilesRepository { get }

    var getMeUseCase: GetMeUseCase { get }
    var loginUseCase: LoginUseCase { get }
    var registerUseCase: RegisterUseCase { get }

    var createInviteUseCase: CreateInviteUseCase { get }
    var getMyCoursesUseCase: GetMyCoursesUseCase { get }
    var joinCourseUseCase: JoinCourseUseCase { get }
    var leaveCourseUseCase: LeaveCourseUseCase { get }
    var removeMemberUseCase: RemoveMemberUseCase { get }
    var revokeInviteUseCase: RevokeInviteUseCase { get }

    var createCourseUseCase: CreateCourseUseCase { get }
    var deleteCourseUseCase: DeleteCourseUseCase { get }
    var getCourseUseCase: GetCourseUseCase { get }
    var updateCourseUseCase: UpdateCourseUseCase { get }

    var createPostCommentUseCase: CreatePostCommentUseCase { get }
    var createPostUseCase: CreatePostUseCase { get }
    var deletePostUseCase: DeletePostUseCase { get }
    var getPostUseCase: GetPostUseCase { get }
    var listPostsUseCase: ListPostsUseCase { get }
    var updatePostUseCase: UpdatePostUseCase { get }

    var createSolutionCommentUseCase: CreateSolutionCommentUseCase { get }
    var deleteSolutionCommentUseCase: DeleteSolutionCommentUseCase { get }
    var deleteSolutionFileUseCase: DeleteSolutionFileUseCase { get }
    var deleteSolutionUseCase: DeleteSolutionUseCase { get }
    var downloadSolutionFileUseCase: DownloadSolutionFileUseCase { get }
    var getMySolutionUseCase: GetMySolutionUseCase { get }
    var getSolutionUseCase: GetSolutionUseCase { get }
    var gradeSolutionUseCase: GradeSolutionUseCase { get }
    var listSolutionCommentsUseCase: ListSolutionCommentsUseCase { get }
    var listSolutionFilesUseCase: ListSolutionFilesUseCase { get }
    var listSolutionsUseCase: ListSolutionsUseCase { get }
    var submitSolutionUseCase: SubmitSolutionUseCase { get }
    var updateSolutionCommentUseCase: UpdateSolutionCommentUseCase { get }
    var updateSolutionUseCase: UpdateSolutionUseCase { get }
    var uploadSolutionFileUseCase: UploadSolutionFileUseCase { get }

    var deletePostMaterialUseCase: DeletePostMaterialUseCase { get }
    var downloadPostMaterialUseCase: DownloadPostMaterialUseCase { get }
    var listPostMaterialsUseCase: ListPostMaterialsUseCase { get }
    var uploadPostMaterialUseCase: UploadPostMaterialUseCase { get }
}