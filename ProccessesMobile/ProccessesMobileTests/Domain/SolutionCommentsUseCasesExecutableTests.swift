//
//  SolutionCommentsUseCasesExecutableTests.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


import Testing
import Foundation
@testable import ProccessesMobile

@Suite("Solution Comments Domain: Executable Specification")
struct SolutionCommentsUseCasesExecutableTests {

    private let dummyComment = Comment(
        id: UUID(),
        text: "Fix line 4",
        author: nil,
        createdAt: Date(),
        updatedAt: Date()
    )

    @Test("Create comment sanitizes text and delegates")
    func createCommentSuccess() async throws {
        let spy = SolutionCommentsRepositorySpy()
        await spy.setCreateResult(.success(dummyComment))

        let sut = DefaultCreateSolutionCommentUseCase(repository: spy)

        let command = CreateSolutionCommentCommand(
            courseId: UUID(),
            postId: UUID(),
            solutionId: UUID(),
            text: "  Fix line 4  \n"
        )

        let result = try await sut.execute(command)

        #expect(result == dummyComment)

        let args = await spy.getRecordedCreateCommands()
        #expect(args.count == 1)
        #expect(args.first?.text == "Fix line 4")
    }

    @Test("Update comment validates string limits")
    func updateCommentValidations() async {
        let spy = SolutionCommentsRepositorySpy()
        let sut = DefaultUpdateSolutionCommentUseCase(repository: spy)

        await #expect(throws: InteractionValidationError.invalidCommentLength(min: 1, max: 5000)) {
            _ = try await sut.execute(
                UpdateSolutionCommentCommand(
                    courseId: UUID(),
                    postId: UUID(),
                    solutionId: UUID(),
                    commentId: UUID(),
                    text: ""
                )
            )
        }
    }

    @Test("List comments bounds pagination")
    func listCommentsPagination() async throws {
        let spy = SolutionCommentsRepositorySpy()
        await spy.setListResult(
            .success(
                Page<ProccessesMobile.Comment>(
                    content: [],
                    page: 0,
                    size: 20,
                    totalElements: 0,
                    totalPages: 0
                )
            )
        )

        let sut = DefaultListSolutionCommentsUseCase(repository: spy)

        _ = try await sut.execute(
            ListSolutionCommentsQuery(
                courseId: UUID(),
                postId: UUID(),
                solutionId: UUID(),
                page: -5,
                size: 500
            )
        )

        let args = await spy.getRecordedListQueries()
        #expect(args.count == 1)
        #expect(args.first?.page == 0)
        #expect(args.first?.size == 100)
    }
}
