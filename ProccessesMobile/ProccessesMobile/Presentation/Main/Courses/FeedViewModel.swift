//
//  FeedViewModel.swift
//  ProccessesMobile
//
//  Created by dark type on 12.03.2026.
//

import Foundation
import Combine

@MainActor
final class FeedViewModel: ObservableObject {
    private let courseId: UUID
    private let listPostsUseCase: ListPostsUseCase
    private weak var navigator: FeedScreenNavigating?

    let role: CourseRole

    @Published var posts: [FeedPostItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    init(
        courseId: UUID,
        role: CourseRole,
        listPostsUseCase: ListPostsUseCase,
        navigator: FeedScreenNavigating?
    ) {
        self.courseId = courseId
        self.role = role
        self.listPostsUseCase = listPostsUseCase
        self.navigator = navigator
    }

    var canCreatePost: Bool {
        role == .teacher
    }

    func onAppear() {
        guard posts.isEmpty, !isLoading else { return }
        loadPosts()
    }

    func refresh() {
        loadPosts()
    }

    func createPostTapped() {
        guard role == .teacher else { return }
        navigator?.openCreatePost(courseId: courseId, type: .material)
    }

    func postTapped(_ post: FeedPostItem) {
        switch post.type {
        case .task:
            navigator?.openTaskDetail(courseId: courseId, postId: post.id)
        case .material:
            navigator?.openMaterialDetail(courseId: courseId, postId: post.id)
        }
    }

    func commentsTapped(for post: FeedPostItem) {
        postTapped(post)
    }

    func attachmentTapped(post: FeedPostItem, attachment: FeedAttachmentItem) {
        postTapped(post)
    }

    private func loadPosts() {
        Task {
            isLoading = true
            errorMessage = nil

            defer { isLoading = false }

            do {
                let page = try await listPostsUseCase.execute(
                    ListPostsQuery(
                        courseId: courseId,
                        page: 0,
                        size: 20,
                        type: nil
                    )
                )

                posts = page.content.map(Self.mapToFeedPostItem)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    private static func mapToFeedPostItem(_ post: Post) -> FeedPostItem {
        FeedPostItem(
            id: post.id,
            type: mapPostType(post.type),
            title: post.title,
            contentPreview: post.content ?? "",
            createdAt: post.createdAt,
            deadline: post.deadline,
            author: FeedAuthorItem(
                displayName: post.author.displayName
            ),
            attachments: [],
            commentsCount: post.commentsCount,
            solutionsCount: mapSolutionsCount(for: post),
            mySolutionId: post.mySolutionId
        )
    }

    private static func mapPostType(_ type: PostType) -> FeedPostType {
        switch type {
        case .material:
            return .material
        case .task:
            return .task
        }
    }

    private static func mapSolutionsCount(for post: Post) -> Int? {
        switch post.type {
        case .material:
            return nil
        case .task:
            return post.solutionsCount
        }
    }
}
