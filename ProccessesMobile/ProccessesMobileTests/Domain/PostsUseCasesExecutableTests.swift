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
    
    func makeCreateSUT(repo: PostRepository) -> CreatePostUseCase { return MockCreatePostUseCase(repo: repo) }
    func makeListSUT(repo: PostRepository) -> ListPostsUseCase { return MockListPostsUseCase(repo: repo) }
    func makeUpdateSUT(repo: PostRepository) -> UpdatePostUseCase { return MockUpdatePostUseCase(repo: repo) }
    
    // MARK: - Create Post Tests
    
    @Test("Create post validates constraints and sanitizes title")
    func createPostSuccess() async throws {
        let repoSpy = PostRepositorySpy()
        let expectedPost = Post(id: "p1", title: "Clean Title", content: nil, type: .task, deadline: nil, author: nil, materialsCount: 0, commentsCount: 0, solutionsCount: 0, mySolutionId: nil, createdAt: "", updatedAt: "")
        
        await repoSpy.setCreateResult(.success(expectedPost))
        let sut = makeCreateSUT(repo: repoSpy)
        
        let result = try await sut.execute(courseId: "c1", request: CreatePostRequest(title: " Clean Title ", type: .task))
        
        #expect(result == expectedPost)
        let args = await repoSpy.getRecordedCreateArgs()
        #expect(args.first?.request.title == "Clean Title")
    }
    
    @Test("Create post catches empty course ID or title lengths", arguments: [
        (" ", "Valid Title", PostValidationError.emptyCourseId),
        ("c1", " ", PostValidationError.invalidTitleLength(min: 1, max: 300)),
        ("c1", String(repeating: "A", count: 301), PostValidationError.invalidTitleLength(min: 1, max: 300))
    ])
    func createPostValidation(courseId: String, title: String, expectedError: PostValidationError) async {
        let repoSpy = PostRepositorySpy()
        let sut = makeCreateSUT(repo: repoSpy)
        
        await #expect(throws: expectedError) {
            try await sut.execute(courseId: courseId, request: CreatePostRequest(title: title, type: .material))
        }
        let args = await repoSpy.getRecordedCreateArgs()
        #expect(args.isEmpty)
    }
    
    // MARK: - List Posts Tests
    
    @Test("List posts sanitizes pagination")
       func listPostsSanitization() async throws {
           let repoSpy = PostRepositorySpy()
           await repoSpy.setListResult(.success(PagePost(content: [], page: 0, size: 20, totalElements: 0, totalPages: 0)))
           let sut = makeListSUT(repo: repoSpy)
           
           let _ = try await sut.execute(courseId: "c1", page: -5, size: 500, type: .material)
           
           let args = await repoSpy.getRecordedListArgs()
           #expect(args.first?.page == 0)
           #expect(args.first?.size == 100)
           #expect(args.first?.type == .material)
       }
       
    
    // MARK: - Update Post Tests
    
    @Test("Update post validates optional title length and handles success")
       func updatePostValidation() async throws {
           let repoSpy = PostRepositorySpy()
           let sut = makeUpdateSUT(repo: repoSpy)
           
           await #expect(throws: PostValidationError.invalidTitleLength(min: 1, max: 300)) {
               let _ = try await sut.execute(courseId: "c1", postId: "p1", request: UpdatePostRequest(title: "   ", content: "New content"))
           }
       }
}
