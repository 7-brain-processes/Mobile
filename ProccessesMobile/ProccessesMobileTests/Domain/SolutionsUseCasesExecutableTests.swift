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
    
    // MARK: - Factories
    func makeSubmitSUT(repo: SolutionRepository) -> SubmitSolutionUseCase { return MockSubmitSolutionUseCase(repo: repo) }
    func makeListSUT(repo: SolutionRepository) -> ListSolutionsUseCase { return MockListSolutionsUseCase(repo: repo) }
    func makeUpdateSUT(repo: SolutionRepository) -> UpdateSolutionUseCase { return MockUpdateSolutionUseCase(repo: repo) }
    func makeGetMySUT(repo: SolutionRepository) -> GetMySolutionUseCase { return MockGetMySolutionUseCase(repo: repo) }
    
    let dummySolution = Solution(id: "s1", text: "Answer", status: .submitted, grade: nil, filesCount: 0, student: nil, submittedAt: "", updatedAt: "", gradedAt: nil)
    
    // MARK: - Submit Solution Tests
    
    @Test("Submit solution sanitizes text and delegates")
    func submitSolutionSuccess() async throws {
        let repoSpy = SolutionRepositorySpy()
        await repoSpy.setSubmitResult(.success(dummySolution))
        let sut = makeSubmitSUT(repo: repoSpy)
        
        let req = CreateSolutionRequest(text: "  My code  ")
        let result = try await sut.execute(courseId: "c1", postId: "p1", request: req)
        
        #expect(result == dummySolution)
        let args = await repoSpy.getRecordedSubmitArgs()
        #expect(args.count == 1)
        #expect(args.first?.request.text == "My code")
    }
    
    @Test("Submit solution validates constraints", arguments: [
        (" ", "p1", "text", SolutionValidationError.emptyCourseId),
        ("c1", "  ", "text", SolutionValidationError.emptyPostId)
    ])
    func submitSolutionIDValidation(cId: String, pId: String, text: String, expectedErr: SolutionValidationError) async {
        let repoSpy = SolutionRepositorySpy()
        let sut = makeSubmitSUT(repo: repoSpy)
        
        await #expect(throws: expectedErr) {
            _ = try await sut.execute(courseId: cId, postId: pId, request: CreateSolutionRequest(text: text))
        }
    }
    
    @Test("Submit solution rejects oversized text")
    func submitSolutionTextTooLong() async {
        let repoSpy = SolutionRepositorySpy()
        let sut = makeSubmitSUT(repo: repoSpy)
        
        let hugeText = String(repeating: "A", count: 10001)
        await #expect(throws: SolutionValidationError.invalidTextLength(max: 10000)) {
            _ = try await sut.execute(courseId: "c1", postId: "p1", request: CreateSolutionRequest(text: hugeText))
        }
    }
    
    // MARK: - List Solutions Tests
    
    @Test("List solutions sanitizes pagination bounds")
    func listSolutionsSanitization() async throws {
        let repoSpy = SolutionRepositorySpy()
        await repoSpy.setListResult(.success(PageSolution(content: [], page: 0, size: 20, totalElements: 0, totalPages: 0)))
        let sut = makeListSUT(repo: repoSpy)
        
        _ = try await sut.execute(courseId: "c1", postId: "p1", page: -5, size: 500, status: .graded)
        
        let args = await repoSpy.getRecordedListArgs()
        #expect(args.first?.page == 0)
        #expect(args.first?.size == 100)
        #expect(args.first?.status == .graded)
    }
    
    // MARK: - Get My Solution Tests
    
    @Test("Get my solution correctly passes IDs")
    func getMySolutionSuccess() async throws {
        let repoSpy = SolutionRepositorySpy()
        await repoSpy.setGetMyResult(.success(dummySolution))
        let sut = makeGetMySUT(repo: repoSpy)
        
        let result = try await sut.execute(courseId: "c1", postId: "p1")
        #expect(result == dummySolution)
        
        let args = await repoSpy.getRecordedGetMyArgs()
        #expect(args.first?.courseId == "c1")
        #expect(args.first?.postId == "p1")
    }
    
    // MARK: - Update Solution Tests
    
    @Test("Update solution rejects empty solution ID")
    func updateSolutionEmptyId() async {
        let repoSpy = SolutionRepositorySpy()
        let sut = makeUpdateSUT(repo: repoSpy)
        
        await #expect(throws: SolutionValidationError.emptySolutionId) {
            _ = try await sut.execute(courseId: "c1", postId: "p1", solutionId: "   ", request: CreateSolutionRequest(text: "new"))
        }
    }
}