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
    
    let dummyComment = Comment(id: "com_1", text: "Fix line 4", author: nil, createdAt: "", updatedAt: "")
    
    @Test("Create comment sanitizes text and delegates")
    func createCommentSuccess() async throws {
        let spy = SolutionCommentsRepositorySpy()
        await spy.setCreateResult(.success(dummyComment))
        let sut = MockCreateSolutionCommentUseCase(repo: spy)
        
        let result = try await sut.execute(courseId: "c1", postId: "p1", solutionId: "s1", request: CreateCommentRequest(text: "  Fix line 4  \n"))
        
        #expect(result == dummyComment)
        let args = await spy.getRecordedCreateArgs()
        #expect(args.first?.req.text == "Fix line 4") // Proves sanitization
    }
    
    @Test("Update comment validates string limits")
    func updateCommentValidations() async {
        let spy = SolutionCommentsRepositorySpy()
        let sut = MockUpdateSolutionCommentUseCase(repo: spy)
        
        await #expect(throws: InteractionValidationError.invalidCommentLength(min: 1, max: 5000)) {
            _ = try await sut.execute(courseId: "c1", postId: "p1", solutionId: "s1", commentId: "com_1", request: CreateCommentRequest(text: ""))
        }
        
        await #expect(throws: InteractionValidationError.emptyId("commentId")) {
            _ = try await sut.execute(courseId: "c1", postId: "p1", solutionId: "s1", commentId: "   ", request: CreateCommentRequest(text: "valid"))
        }
    }
    
    @Test("List comments bounds pagination")
    func listCommentsPagination() async throws {
        let spy = SolutionCommentsRepositorySpy()
        await spy.setListResult(.success(PageComment(content: [], page: 0, size: 20, totalElements: 0, totalPages: 0)))
        let sut = MockListSolutionCommentsUseCase(repo: spy)
        
        _ = try await sut.execute(courseId: "c1", postId: "p1", solutionId: "s1", page: -5, size: 500)
        
        let args = await spy.getRecordedListArgs()
        #expect(args.first?.page == 0)
        #expect(args.first?.size == 100)
    }
}