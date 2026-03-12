//
//  SolutionCommentsRepositoriesExecutableTests.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


import Testing
import Foundation
@testable import ProccessesMobile

@Suite("Solution Comments Data: Repository Executable Specification")
struct SolutionCommentsRepositoriesExecutableTests {

    private let anyURL = URL(string: "http://localhost:8080/api/v1")!

    private let courseId = UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!
    private let postId = UUID(uuidString: "550e8400-e29b-41d4-a716-446655440002")!
    private let solutionId = UUID(uuidString: "550e8400-e29b-41d4-a716-446655440003")!
    private let commentId = UUID(uuidString: "550e8400-e29b-41d4-a716-446655440123")!

    private func makeCommentJSON() -> Data {
        """
        {
            "id": "550e8400-e29b-41d4-a716-446655440123",
            "text": "Great logic here!",
            "author": null,
            "createdAt": "2026-03-06T10:00:00Z",
            "updatedAt": "2026-03-06T10:00:00Z"
        }
        """.data(using: .utf8)!
    }

    // MARK: - Create

    @Test("Create solution comment routes correctly and sends POST JSON")
    func createRouting() async throws {
        let clientSpy = HTTPClientSpy()

        clientSpy.addStub(
            .success(
                (
                    makeCommentJSON(),
                    HTTPURLResponse(url: anyURL, statusCode: 201, httpVersion: nil, headerFields: nil)!
                )
            )
        )

        let sut = DefaultSolutionCommentsRepositoryImpl(client: clientSpy, baseURL: anyURL)

        let result = try await sut.createComment(
            CreateSolutionCommentCommand(
                courseId: courseId,
                postId: postId,
                solutionId: solutionId,
                text: "Great logic here!"
            )
        )

        #expect(result.id == commentId)

        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)

        #expect(sentRequest.httpMethod == "POST")

        #expect(
            sentRequest.url?.absoluteString ==
            "http://localhost:8080/api/v1/courses/\(courseId.uuidString)/posts/\(postId.uuidString)/solutions/\(solutionId.uuidString)/comments"
        )

        let bodyData = try #require(sentRequest.httpBody)
        let sentBody = try JSONDecoder().decode(CreateCommentRequestDTO.self, from: bodyData)
        #expect(sentBody.text == "Great logic here!")
    }

    // MARK: - Update

    @Test("Update solution comment uses PUT to specific comment ID")
    func updateRouting() async throws {
        let clientSpy = HTTPClientSpy()

        clientSpy.addStub(
            .success(
                (
                    makeCommentJSON(),
                    HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
                )
            )
        )

        let sut = DefaultSolutionCommentsRepositoryImpl(client: clientSpy, baseURL: anyURL)

        _ = try await sut.updateComment(
            UpdateSolutionCommentCommand(
                courseId: courseId,
                postId: postId,
                solutionId: solutionId,
                commentId: commentId,
                text: "Edit"
            )
        )

        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)

        #expect(sentRequest.httpMethod == "PUT")

        #expect(
            sentRequest.url?.absoluteString ==
            "http://localhost:8080/api/v1/courses/\(courseId.uuidString)/posts/\(postId.uuidString)/solutions/\(solutionId.uuidString)/comments/\(commentId.uuidString)"
        )
    }

    // MARK: - Delete

    @Test("Delete solution comment uses DELETE method")
    func deleteRouting() async throws {
        let clientSpy = HTTPClientSpy()

        clientSpy.addStub(
            .success(
                (
                    Data(),
                    HTTPURLResponse(url: anyURL, statusCode: 204, httpVersion: nil, headerFields: nil)!
                )
            )
        )

        let sut = DefaultSolutionCommentsRepositoryImpl(client: clientSpy, baseURL: anyURL)

        try await sut.deleteComment(
            DeleteSolutionCommentCommand(
                courseId: courseId,
                postId: postId,
                solutionId: solutionId,
                commentId: commentId
            )
        )

        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)

        #expect(sentRequest.httpMethod == "DELETE")

        #expect(
            sentRequest.url?.absoluteString ==
            "http://localhost:8080/api/v1/courses/\(courseId.uuidString)/posts/\(postId.uuidString)/solutions/\(solutionId.uuidString)/comments/\(commentId.uuidString)"
        )
    }
}
