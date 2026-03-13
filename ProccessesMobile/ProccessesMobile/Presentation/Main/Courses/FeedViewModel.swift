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
    private weak var navigator: FeedScreenNavigating?

    let role: CourseRole
    @Published var posts: [FeedPostItem]

    init(
        courseId: UUID,
        role: CourseRole,
        navigator: FeedScreenNavigating?,
        posts: [FeedPostItem] = FeedViewModel.mockPosts
    ) {
        self.courseId = courseId
        self.role = role
        self.navigator = navigator
        self.posts = posts
    }

    var canCreatePost: Bool {
        role == .teacher
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
}

extension FeedViewModel {
    static let mockPosts: [FeedPostItem] = [
        FeedPostItem(
            id: UUID(),
            type: .material,
            title: "Lecture slides",
            contentPreview: "Review these slides before the next lesson.",
            createdAt: Date(),
            deadline: nil,
            author: FeedAuthorItem(displayName: "Professor Adams"),
            attachments: [
                FeedAttachmentItem(id: UUID(), type: .image, fileName: "slides-1.png", previewURL: nil),
                FeedAttachmentItem(id: UUID(), type: .image, fileName: "slides-2.png", previewURL: nil)
            ],
            commentsCount: 4,
            solutionsCount: nil,
            mySolutionId: nil
        ),
        FeedPostItem(
            id: UUID(),
            type: .task,
            title: "Homework 1",
            contentPreview: "Solve the first five problems and attach your work.",
            createdAt: Date(),
            deadline: Calendar.current.date(byAdding: .day, value: 3, to: Date()),
            author: FeedAuthorItem(displayName: "Professor Adams"),
            attachments: [
                FeedAttachmentItem(id: UUID(), type: .image, fileName: "worksheet.png", previewURL: nil)
            ],
            commentsCount: 7,
            solutionsCount: 12,
            mySolutionId: nil
        )
    ]
}
