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

    private func makeCommentSUT(repo: PostCommentsRepository) -> CreatePostCommentUseCase {
        DefaultCreatePostCommentUseCase(repository: repo)
    }

    private func makeGradeSUT(repo: GradingRepository) -> GradeSolutionUseCase {
        DefaultGradeSolutionUseCase(repository: repo)
    }

    // MARK: - Post Comments Tests

    @Test("Create comment sanitizes text and delegates successfully")
    func createCommentSuccess() async throws {
        let repoSpy = PostCommentsRepositorySpy()

        let expectedComment = ProccessesMobile.Comment(
            id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440111")!,
            text: "Clean Text",
            author: nil,
            createdAt: Date(),
            updatedAt: Date()
        )

        await repoSpy.setCreateResult(.success(expectedComment))
        let sut = makeCommentSUT(repo: repoSpy)

        let command = CreatePostCommentCommand(
            courseId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!,
            postId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440002")!,
            text: "  Clean Text  \n"
        )

        let result = try await sut.execute(command)

        #expect(result == expectedComment)

        let commands = await repoSpy.getRecordedCreateCommands()
        #expect(commands.count == 1)
        #expect(commands.first?.text == "Clean Text")
    }

    @Test("Create comment validation fails on empty or overly long text", arguments: [
        ("   ", InteractionValidationError.invalidCommentLength(min: 1, max: 5000)),
        (String(repeating: "A", count: 5001), InteractionValidationError.invalidCommentLength(min: 1, max: 5000))
    ])
    func createCommentValidationFails(invalidText: String, expectedError: InteractionValidationError) async {
        let repoSpy = PostCommentsRepositorySpy()
        let sut = makeCommentSUT(repo: repoSpy)

        await #expect(throws: expectedError) {
            _ = try await sut.execute(
                CreatePostCommentCommand(
                    courseId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!,
                    postId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440002")!,
                    text: invalidText
                )
            )
        }
    }

    // MARK: - Grading Tests

    @Test("Grade solution accepts valid boundaries and delegates")
    func gradeSolutionSuccess() async throws {
        let repoSpy = GradingRepositorySpy()

        let dummySolution = ProccessesMobile.Solution(
            id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440222")!,
            text: nil,
            status: .graded,
            grade: 100,
            filesCount: 0,
            student: nil,
            submittedAt: Date(),
            updatedAt: Date(),
            gradedAt: Date()
        )

        await repoSpy.setGradeResult(.success(dummySolution))
        let sut = makeGradeSUT(repo: repoSpy)

        let command = GradeSolutionCommand(
            courseId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!,
            postId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440002")!,
            solutionId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440222")!,
            grade: 100,
            comment: "Perfect!"
        )

        let result = try await sut.execute(command)

        #expect(result == dummySolution)

        let commands = await repoSpy.getRecordedGradeCommands()
        #expect(commands.count == 1)
        #expect(commands.first?.grade == 100)
        #expect(commands.first?.comment == "Perfect!")
    }

    @Test("Grade solution catches out-of-bounds grades", arguments: [
        -1, 101, 500
    ])
    func gradeSolutionInvalidGrade(invalidGrade: Int) async {
        let repoSpy = GradingRepositorySpy()
        let sut = makeGradeSUT(repo: repoSpy)

        await #expect(throws: InteractionValidationError.invalidGrade(min: 0, max: 100)) {
            _ = try await sut.execute(
                GradeSolutionCommand(
                    courseId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!,
                    postId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440002")!,
                    solutionId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440222")!,
                    grade: invalidGrade,
                    comment: nil
                )
            )
        }
    }

    @Test("Grade solution catches oversized feedback comment")
    func gradeSolutionOversizedFeedback() async {
        let repoSpy = GradingRepositorySpy()
        let sut = makeGradeSUT(repo: repoSpy)

        let hugeFeedback = String(repeating: "B", count: 5001)

        await #expect(throws: InteractionValidationError.invalidCommentLength(min: 0, max: 5000)) {
            _ = try await sut.execute(
                GradeSolutionCommand(
                    courseId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!,
                    postId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440002")!,
                    solutionId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440222")!,
                    grade: 85,
                    comment: hugeFeedback
                )
            )
        }
    }
}
