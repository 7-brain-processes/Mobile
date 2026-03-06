//
//  CommentsAndGradingRepositoriesExecutableTests.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


import Testing
import Foundation
@testable import ProccessesMobile

@Suite("Comments & Grading Data: Repository Executable Specification")
struct CommentsAndGradingRepositoriesExecutableTests {
    
    let anyURL = URL(string: "http://localhost:8080/api/v1")!
    
    // MARK: - JSON Helpers
    
    private func makeCommentJSON() -> Data {
        return """
        {
            "id": "com_123",
            "text": "Could you clarify question 3?",
            "author": null,
            "createdAt": "2026-03-06T10:00:00Z",
            "updatedAt": "2026-03-06T10:00:00Z"
        }
        """.data(using: .utf8)!
    }
    
    private func makeSolutionJSON() -> Data {
        return """
        {
            "id": "sol_1",
            "text": "Answer",
            "status": "GRADED",
            "grade": 95,
            "filesCount": 0,
            "student": null,
            "submittedAt": "2026-03-06T10:00:00Z",
            "updatedAt": "2026-03-06T10:00:00Z",
            "gradedAt": "2026-03-06T11:00:00Z"
        }
        """.data(using: .utf8)!
    }
    
    // MARK: - Post Comments Tests
    
    @Test("Create comment sends POST with correctly encoded body")
    func createCommentRouting() async throws {
        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(.success((makeCommentJSON(), HTTPURLResponse(url: anyURL, statusCode: 201, httpVersion: nil, headerFields: nil)!)))
        let sut = MockPostCommentsRepositoryImpl(client: clientSpy, baseURL: anyURL)
        
        let reqBody = CreateCommentRequest(text: "Could you clarify question 3?")
        let result = try await sut.createComment(courseId: "c1", postId: "p1", request: reqBody)
        
        #expect(result.id == "com_123")
        
        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)
        
        #expect(sentRequest.httpMethod == "POST")
        #expect(sentRequest.url?.absoluteString == "http://localhost:8080/api/v1/courses/c1/posts/p1/comments")
        
        let sentBody = try JSONDecoder().decode(CreateCommentRequest.self, from: try #require(sentRequest.httpBody))
        #expect(sentBody.text == "Could you clarify question 3?")
    }
    
    @Test("Delete comment uses DELETE method on exact subpath")
    func deleteCommentRouting() async throws {
        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(.success((Data(), HTTPURLResponse(url: anyURL, statusCode: 204, httpVersion: nil, headerFields: nil)!)))
        let sut = MockPostCommentsRepositoryImpl(client: clientSpy, baseURL: anyURL)
        
        try await sut.deleteComment(courseId: "c1", postId: "p1", commentId: "com_123")
        
        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)
        #expect(sentRequest.httpMethod == "DELETE")
        #expect(sentRequest.url?.absoluteString == "http://localhost:8080/api/v1/courses/c1/posts/p1/comments/com_123")
    }
    
    // MARK: - Grading Tests
    
    @Test("Grade solution sends PUT request and maps 200 properly")
    func gradeSolutionRouting() async throws {
        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(.success((makeSolutionJSON(), HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!)))
        let sut = MockGradingRepositoryImpl(client: clientSpy, baseURL: anyURL)
        
        let reqBody = GradeRequest(grade: 95, comment: "Great work")
        let result = try await sut.gradeSolution(courseId: "c1", postId: "p1", solutionId: "sol_1", request: reqBody)
        
        #expect(result.grade == 95)
        #expect(result.status == .graded)
        
        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)
        
        #expect(sentRequest.httpMethod == "PUT")
        #expect(sentRequest.url?.absoluteString == "http://localhost:8080/api/v1/courses/c1/posts/p1/solutions/sol_1/grade")
        
        let sentBody = try JSONDecoder().decode(GradeRequest.self, from: try #require(sentRequest.httpBody))
        #expect(sentBody.grade == 95)
        #expect(sentBody.comment == "Great work")
    }
    
    @Test("Grade solution maps 403 Forbidden correctly")
    func gradeSolutionForbidden() async {
        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(.success((Data(), HTTPURLResponse(url: anyURL, statusCode: 403, httpVersion: nil, headerFields: nil)!)))
        let sut = MockGradingRepositoryImpl(client: clientSpy, baseURL: anyURL)
        
        await #expect(throws: APIError.serverError(code: 403)) {
            _ = try await sut.gradeSolution(courseId: "c1", postId: "p1", solutionId: "sol_1", request: GradeRequest(grade: 100))
        }
    }
}