//
//  CommentsAndGradingUseCasesExecutableTests.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


import Testing
import Foundation
@testable import ProccessesMobile

@Suite("Comments & Grading Domain: Executable Specification")
struct CommentsAndGradingUseCasesExecutableTests {
    
    func makeCommentSUT(repo: PostCommentsRepository) -> CreatePostCommentUseCase { return MockCreatePostCommentUseCase(repository: repo) }
    func makeGradeSUT(repo: GradingRepository) -> GradeSolutionUseCase { return MockGradeSolutionUseCase(repository: repo) }
    
    // MARK: - Post Comments Tests
    
    @Test("Create comment sanitizes text and delegates successfully")
    func createCommentSuccess() async throws {
        let repoSpy = PostCommentsRepositorySpy()
        let expectedComment = Comment(id: "com_1", text: "Clean Text", author: nil, createdAt: "", updatedAt: "")
        await repoSpy.setCreateResult(.success(expectedComment))
        let sut = makeCommentSUT(repo: repoSpy)
        
        let result = try await sut.execute(courseId: "c1", postId: "p1", request: CreateCommentRequest(text: "  Clean Text  \n"))
        
        #expect(result == expectedComment)
        let args = await repoSpy.getRecordedCreateArgs()
        #expect(args.first?.request.text == "Clean Text")
    }
    
    @Test("Create comment validation fails on empty or overly long text", arguments: [
        ("   ", InteractionValidationError.invalidCommentLength(min: 1, max: 5000)),
        (String(repeating: "A", count: 5001), InteractionValidationError.invalidCommentLength(min: 1, max: 5000))
    ])
    func createCommentValidationFails(invalidText: String, expectedError: InteractionValidationError) async {
        let repoSpy = PostCommentsRepositorySpy()
        let sut = makeCommentSUT(repo: repoSpy)
        
        await #expect(throws: expectedError) {
            _ = try await sut.execute(courseId: "c1", postId: "p1", request: CreateCommentRequest(text: invalidText))
        }
    }
    
    // MARK: - Grading Tests
    
    @Test("Grade solution accepts valid boundaries and delegates")
    func gradeSolutionSuccess() async throws {
        let repoSpy = GradingRepositorySpy()
        let dummySolution = Solution(id: "s1", text: nil, status: .graded, grade: 100, filesCount: 0, student: nil, submittedAt: "", updatedAt: "", gradedAt: "")
        await repoSpy.setGradeResult(.success(dummySolution))
        let sut = makeGradeSUT(repo: repoSpy)
        
        let result = try await sut.execute(courseId: "c1", postId: "p1", solutionId: "s1", request: GradeRequest(grade: 100, comment: "Perfect!"))
        
        #expect(result == dummySolution)
        let args = await repoSpy.getRecordedGradeArgs()
        #expect(args.first?.request.grade == 100)
    }
    
    @Test("Grade solution catches out-of-bounds grades", arguments: [
        -1, 101, 500
    ])
    func gradeSolutionInvalidGrade(invalidGrade: Int) async {
        let repoSpy = GradingRepositorySpy()
        let sut = makeGradeSUT(repo: repoSpy)
        
        await #expect(throws: InteractionValidationError.invalidGrade(min: 0, max: 100)) {
            _ = try await sut.execute(courseId: "c1", postId: "p1", solutionId: "s1", request: GradeRequest(grade: invalidGrade))
        }
    }
    
    @Test("Grade solution catches oversized feedback comment")
    func gradeSolutionOversizedFeedback() async {
        let repoSpy = GradingRepositorySpy()
        let sut = makeGradeSUT(repo: repoSpy)
        
        let hugeFeedback = String(repeating: "B", count: 5001)
        
        await #expect(throws: InteractionValidationError.invalidCommentLength(min: 0, max: 5000)) {
            _ = try await sut.execute(courseId: "c1", postId: "p1", solutionId: "s1", request: GradeRequest(grade: 85, comment: hugeFeedback))
        }
    }
}