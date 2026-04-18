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
            createPostUseCase: useCase
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
    
    func makeTaskDetailViewModel(postId: UUID) -> TaskDetailViewModel {
        TaskDetailViewModel(
            role: .teacher,
            item: TaskDetailItem(
                id: postId,
                title: "Homework 1",
                content: "Solve the first five problems and attach your work.",
                createdAt: Date(),
                deadline: Calendar.current.date(byAdding: .day, value: 3, to: Date()),
                authorDisplayName: "Professor Adams",
                attachments: [
                    FeedAttachmentItem(id: UUID(), type: .image, fileName: "worksheet-1.png", previewURL: nil),
                    FeedAttachmentItem(id: UUID(), type: .file, fileName: "requirements.pdf", previewURL: nil)
                ],
                comments: [
                    PostCommentItem(
                        id: UUID(),
                        authorName: "Alice Brown",
                        text: "Can I submit handwritten work?",
                        createdAt: Date()
                    ),
                    PostCommentItem(
                        id: UUID(),
                        authorName: "Professor Adams",
                        text: "Yes, as long as it is readable.",
                        createdAt: Date()
                    )
                ]
            ),
            studentAttachments: [
                FeedAttachmentItem(id: UUID(), type: .image, fileName: "answer-1.jpg", previewURL: nil)
            ],
            studentSubmissionText: "I solved all five tasks. Please check my approach in question 4.",
            studentSubmissionStatus: .draft,
            studentTeacherComments: [
                TeacherReviewCommentItem(
                    id: UUID(),
                    authorName: "Professor Adams",
                    text: "Please revise the last exercise.",
                    createdAt: Date()
                )
            ],
            submissions: [
                TaskSubmissionItem(
                    id: UUID(),
                    studentName: "Alice Brown",
                    submittedAt: Date(),
                    status: .submitted,
                    text: "Please see attached work. I was unsure about task 2.",
                    grade: 85,
                    teacherComments: [
                        TeacherReviewCommentItem(
                            id: UUID(),
                            authorName: "Professor Adams",
                            text: "Good structure, but improve problem 2.",
                            createdAt: Date()
                        )
                    ],
                    attachments: [
                        FeedAttachmentItem(id: UUID(), type: .image, fileName: "alice-1.jpg", previewURL: nil),
                        FeedAttachmentItem(id: UUID(), type: .file, fileName: "alice-notes.pdf", previewURL: nil)
                    ],
                    isLate: false
                ),
                TaskSubmissionItem(
                    id: UUID(),
                    studentName: "Bob Green",
                    submittedAt: Date(),
                    status: .submitted,
                    text: "I had difficulty with the final question.",
                    grade: nil,
                    teacherComments: [
                        TeacherReviewCommentItem(
                            id: UUID(),
                            authorName: "Professor Adams",
                            text: "Please expand your reasoning in task 5.",
                            createdAt: Date()
                        )
                    ],
                    attachments: [
                        FeedAttachmentItem(id: UUID(), type: .image, fileName: "bob-1.jpg", previewURL: nil)
                    ],
                    isLate: true
                )
            ]
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

    func makeCourseCategoriesViewModel(courseId: UUID) -> CourseCategoriesViewModel {
        CourseCategoriesViewModel(
            courseId: courseId,
            listCourseCategoriesUseCase: listCourseCategoriesUseCase
        )
    }
}
