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

    private let anyURL = URL(string: "http://localhost:8080/api/v1")!

    private let courseId = UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!
    private let postId = UUID(uuidString: "550e8400-e29b-41d4-a716-446655440002")!
    private let commentId = UUID(uuidString: "550e8400-e29b-41d4-a716-446655440111")!
    private let solutionId = UUID(uuidString: "550e8400-e29b-41d4-a716-446655440222")!

    // MARK: - JSON Helpers

    private func makeCommentJSON() -> Data {
        """
        {
            "id": "550e8400-e29b-41d4-a716-446655440111",
            "text": "Could you clarify question 3?",
            "author": null,
            "createdAt": "2026-03-06T10:00:00Z",
            "updatedAt": "2026-03-06T10:00:00Z"
        }
        """.data(using: .utf8)!
    }

    private func makeSolutionJSON() -> Data {
        """
        {
            "id": "550e8400-e29b-41d4-a716-446655440222",
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

        clientSpy.addStub(
            .success(
                (
                    makeCommentJSON(),
                    HTTPURLResponse(url: anyURL, statusCode: 201, httpVersion: nil, headerFields: nil)!
                )
            )
        )

        let sut = MockPostCommentsRepositoryImpl(client: clientSpy, baseURL: anyURL)

        let command = CreatePostCommentCommand(
            courseId: courseId,
            postId: postId,
            text: "Could you clarify question 3?"
        )

        let result = try await sut.createComment(command)

        #expect(result.id == commentId)
        #expect(result.text == "Could you clarify question 3?")

        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)

        #expect(sentRequest.httpMethod == "POST")

        #expect(
            sentRequest.url?.absoluteString ==
            "http://localhost:8080/api/v1/courses/\(courseId.uuidString)/posts/\(postId.uuidString)/comments"
        )

        let sentBody = try JSONDecoder().decode(
            CreateCommentRequestDTO.self,
            from: try #require(sentRequest.httpBody)
        )

        #expect(sentBody.text == "Could you clarify question 3?")
    }

    @Test("Delete comment uses DELETE method on exact subpath")
    func deleteCommentRouting() async throws {

        let clientSpy = HTTPClientSpy()

        clientSpy.addStub(
            .success(
                (
                    Data(),
                    HTTPURLResponse(url: anyURL, statusCode: 204, httpVersion: nil, headerFields: nil)!
                )
            )
        )

        let sut = MockPostCommentsRepositoryImpl(client: clientSpy, baseURL: anyURL)

        try await sut.deleteComment(
            DeletePostCommentCommand(
                courseId: courseId,
                postId: postId,
                commentId: commentId
            )
        )

        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)

        #expect(sentRequest.httpMethod == "DELETE")

        #expect(
            sentRequest.url?.absoluteString ==
            "http://localhost:8080/api/v1/courses/\(courseId.uuidString)/posts/\(postId.uuidString)/comments/\(commentId.uuidString)"
        )
    }

    // MARK: - Grading Tests

    @Test("Grade solution sends PUT request and maps 200 properly")
    func gradeSolutionRouting() async throws {

        let clientSpy = HTTPClientSpy()

        clientSpy.addStub(
            .success(
                (
                    makeSolutionJSON(),
                    HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
                )
            )
        )

        let sut = MockGradingRepositoryImpl(client: clientSpy, baseURL: anyURL)

        let command = GradeSolutionCommand(
            courseId: courseId,
            postId: postId,
            solutionId: solutionId,
            grade: 95,
            comment: "Great work"
        )

        let result = try await sut.gradeSolution(command)

        #expect(result.grade == 95)
        #expect(result.status == .graded)

        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)

        #expect(sentRequest.httpMethod == "PUT")

        #expect(
            sentRequest.url?.absoluteString ==
            "http://localhost:8080/api/v1/courses/\(courseId.uuidString)/posts/\(postId.uuidString)/solutions/\(solutionId.uuidString)/grade"
        )

        let sentBody = try JSONDecoder().decode(
            GradeRequestDTO.self,
            from: try #require(sentRequest.httpBody)
        )

        #expect(sentBody.grade == 95)
        #expect(sentBody.comment == "Great work")
    }

    @Test("Grade solution maps 403 Forbidden correctly")
    func gradeSolutionForbidden() async {

        let clientSpy = HTTPClientSpy()

        clientSpy.addStub(
            .success(
                (
                    Data(),
                    HTTPURLResponse(url: anyURL, statusCode: 403, httpVersion: nil, headerFields: nil)!
                )
            )
        )

        let sut = MockGradingRepositoryImpl(client: clientSpy, baseURL: anyURL)

        await #expect(throws: APIError.serverError(code: 403)) {
            _ = try await sut.gradeSolution(
                GradeSolutionCommand(
                    courseId: courseId,
                    postId: postId,
                    solutionId: solutionId,
                    grade: 100,
                    comment: nil
                )
            )
        }
    }
}
