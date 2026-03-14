//
//  PostsUseCasesExecutableTests.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


import Testing
import Foundation
@testable import ProccessesMobile

@Suite("Post Domain: Executable Specification")
struct PostsUseCasesExecutableTests {

    func makeCreateSUT(repo: PostRepository) -> CreatePostUseCase {
        DefaultCreatePostUseCase(repository: repo)
    }

    func makeListSUT(repo: PostRepository) -> ListPostsUseCase {
        DefaultListPostsUseCase(repository: repo)
    }

    func makeUpdateSUT(repo: PostRepository) -> UpdatePostUseCase {
        DefaultUpdatePostUseCase(repository: repo)
    }

    // MARK: - Create Post Tests

    @Test("Create post validates constraints and sanitizes title")
    func createPostSuccess() async throws {
        let repoSpy = PostRepositorySpy()

        let courseId = UUID()
        let postId = UUID()
        let now = Date()

        let expectedPost = Post(
            id: postId,
            title: "Clean Title",
            content: nil,
            type: .task,
            deadline: nil,
            author: nil,
            materialsCount: 0,
            commentsCount: 0,
            solutionsCount: 0,
            mySolutionId: nil,
            createdAt: now,
            updatedAt: now
        )

        await repoSpy.setCreateResult(.success(expectedPost))
        let sut = makeCreateSUT(repo: repoSpy)

        let result = try await sut.execute(
            CreatePostCommand(
                courseId: courseId,
                title: " Clean Title ",
                content: nil,
                type: .task,
                deadline: nil
            )
        )

        #expect(result == expectedPost)

        let commands = await repoSpy.getRecordedCreateCommands()
        #expect(commands.count == 1)
        #expect(commands.first?.courseId == courseId)
        #expect(commands.first?.title == "Clean Title")
        #expect(commands.first?.type == .task)
    }

    @Test("Create post catches invalid title lengths", arguments: [
        " ",
        String(repeating: "A", count: 301)
    ])
    func createPostValidation(title: String) async {
        let repoSpy = PostRepositorySpy()
        let sut = makeCreateSUT(repo: repoSpy)

        await #expect(throws: PostValidationError.invalidTitleLength(min: 1, max: 300)) {
            try await sut.execute(
                CreatePostCommand(
                    courseId: UUID(),
                    title: title,
                    content: nil,
                    type: .material,
                    deadline: nil
                )
            )
        }

        let commands = await repoSpy.getRecordedCreateCommands()
        #expect(commands.isEmpty)
    }

    // MARK: - List Posts Tests

    @Test("List posts sanitizes pagination")
    func listPostsSanitization() async throws {
        let repoSpy = PostRepositorySpy()

        await repoSpy.setListResult(
            .success(
                Page(
                    content: [],
                    page: 0,
                    size: 20,
                    totalElements: 0,
                    totalPages: 0
                )
            )
        )

        let sut = makeListSUT(repo: repoSpy)

        _ = try await sut.execute(
            ListPostsQuery(
                courseId: UUID(),
                page: -5,
                size: 500,
                type: .material
            )
        )

        let queries = await repoSpy.getRecordedListQueries()
        #expect(queries.count == 1)
        #expect(queries.first?.page == 0)
        #expect(queries.first?.size == 100)
        #expect(queries.first?.type == .material)
    }

    // MARK: - Update Post Tests

    @Test("Update post validates optional title length and handles success")
    func updatePostValidation() async throws {
        let repoSpy = PostRepositorySpy()
        let sut = makeUpdateSUT(repo: repoSpy)

        await #expect(throws: PostValidationError.invalidTitleLength(min: 1, max: 300)) {
            try await sut.execute(
                UpdatePostCommand(
                    courseId: UUID(),
                    postId: UUID(),
                    title: "   ",
                    content: "New content",
                    deadline: nil
                )
            )
        }

        let commands = await repoSpy.getRecordedUpdateCommands()
        #expect(commands.isEmpty)
    }
}
