//
//  SolutionsUseCasesExecutableTests.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


import Testing
import Foundation
@testable import ProccessesMobile

@Suite("Solutions Domain: Executable Specification")
struct SolutionsUseCasesExecutableTests {

    private let dummySolution = ProccessesMobile.Solution(
        id: UUID(),
        text: "Answer",
        status: .submitted,
        grade: nil,
        filesCount: 0,
        student: nil,
        submittedAt: Date(),
        updatedAt: Date(),
        gradedAt: nil
    )

    // MARK: - Submit Solution Tests

    @Test("Submit solution sanitizes text and delegates")
    func submitSolutionSuccess() async throws {
        let repoSpy = SolutionRepositorySpy()
        await repoSpy.setSubmitResult(.success(dummySolution))
        let sut = DefaultSubmitSolutionUseCase(repository: repoSpy)

        let command = SubmitSolutionCommand(
            courseId: UUID(),
            postId: UUID(),
            text: "  My code  "
        )

        let result = try await sut.execute(command)

        #expect(result == dummySolution)

        let commands = await repoSpy.getRecordedSubmitCommands()
        #expect(commands.count == 1)
        #expect(commands.first?.text == "My code")
    }

    @Test("Submit solution rejects oversized text")
    func submitSolutionTextTooLong() async {
        let repoSpy = SolutionRepositorySpy()
        let sut = DefaultSubmitSolutionUseCase(repository: repoSpy)

        let hugeText = String(repeating: "A", count: 10001)

        await #expect(throws: SolutionValidationError.invalidTextLength(max: 10000)) {
            _ = try await sut.execute(
                SubmitSolutionCommand(
                    courseId: UUID(),
                    postId: UUID(),
                    text: hugeText
                )
            )
        }
    }

    // MARK: - List Solutions Tests

    @Test("List solutions sanitizes pagination bounds")
    func listSolutionsSanitization() async throws {
        let repoSpy = SolutionRepositorySpy()
        await repoSpy.setListResult(
            .success(
                Page<ProccessesMobile.Solution>(
                    content: [],
                    page: 0,
                    size: 20,
                    totalElements: 0,
                    totalPages: 0
                )
            )
        )

        let sut = DefaultListSolutionsUseCase(repository: repoSpy)

        _ = try await sut.execute(
            ListSolutionsQuery(
                courseId: UUID(),
                postId: UUID(),
                page: -5,
                size: 500,
                status: .graded
            )
        )

        let queries = await repoSpy.getRecordedListQueries()
        #expect(queries.count == 1)
        #expect(queries.first?.page == 0)
        #expect(queries.first?.size == 100)
        #expect(queries.first?.status == .graded)
    }

    // MARK: - Get My Solution Tests

    @Test("Get my solution correctly passes IDs")
    func getMySolutionSuccess() async throws {
        let repoSpy = SolutionRepositorySpy()
        await repoSpy.setGetMyResult(.success(dummySolution))
        let sut = DefaultGetMySolutionUseCase(repository: repoSpy)

        let query = GetMySolutionQuery(
            courseId: UUID(),
            postId: UUID()
        )

        let result = try await sut.execute(query)
        #expect(result == dummySolution)

        let queries = await repoSpy.getRecordedGetMyQueries()
        #expect(queries.count == 1)
        #expect(queries.first?.courseId == query.courseId)
        #expect(queries.first?.postId == query.postId)
    }

    // MARK: - Update Solution Tests

    @Test("Update solution sanitizes text and delegates")
    func updateSolutionSuccess() async throws {
        let repoSpy = SolutionRepositorySpy()
        await repoSpy.setUpdateResult(.success(dummySolution))
        let sut = DefaultUpdateSolutionUseCase(repository: repoSpy)

        let command = UpdateSolutionCommand(
            courseId: UUID(),
            postId: UUID(),
            solutionId: UUID(),
            text: "  updated answer  "
        )

        let result = try await sut.execute(command)
        #expect(result == dummySolution)

        let commands = await repoSpy.getRecordedUpdateCommands()
        #expect(commands.count == 1)
        #expect(commands.first?.text == "updated answer")
    }

    @Test("Update solution rejects oversized text")
    func updateSolutionTextTooLong() async {
        let repoSpy = SolutionRepositorySpy()
        let sut = DefaultUpdateSolutionUseCase(repository: repoSpy)

        let hugeText = String(repeating: "B", count: 10001)

        await #expect(throws: SolutionValidationError.invalidTextLength(max: 10000)) {
            _ = try await sut.execute(
                UpdateSolutionCommand(
                    courseId: UUID(),
                    postId: UUID(),
                    solutionId: UUID(),
                    text: hugeText
                )
            )
        }
    }
}
