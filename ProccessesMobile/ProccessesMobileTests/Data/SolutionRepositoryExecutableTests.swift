//
//  SolutionRepositoryExecutableTests.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


import Testing
import Foundation
@testable import ProccessesMobile

@Suite("Solutions Data: Repository Executable Specification")
struct SolutionRepositoryExecutableTests {

    private let anyURL = URL(string: "http://localhost:8080/api/v1")!

    private let courseId = UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!
    private let postId = UUID(uuidString: "550e8400-e29b-41d4-a716-446655440002")!
    private let solutionId = UUID(uuidString: "550e8400-e29b-41d4-a716-446655440003")!

    // MARK: - Factory

    private func makeAPIClient(_ client: HTTPClient) -> APIClient {
        APIClient(
            httpClient: client,
            configuration: APIConfiguration(baseURL: anyURL)
        )
    }

    private func makeSUT(_ client: HTTPClient) -> SolutionRepository {
        DefaultSolutionRepository(
            apiClient: makeAPIClient(client)
        )
    }

    // MARK: - JSON Builders

    private func makeSolutionJSON() -> Data {
        """
        {
            "id": "550e8400-e29b-41d4-a716-446655440123",
            "text": "My answer code.",
            "status": "SUBMITTED",
            "grade": null,
            "filesCount": 0,
            "student": null,
            "submittedAt": "2026-03-06T10:00:00Z",
            "updatedAt": "2026-03-06T10:00:00Z",
            "gradedAt": null
        }
        """.data(using: .utf8)!
    }

    // MARK: - List

    @Test("List solutions constructs correct URL and query parameters")
    func listSolutionsRouting() async throws {

        let clientSpy = HTTPClientSpy()

        let solutionString = try #require(String(data: makeSolutionJSON(), encoding: .utf8))
        let pageJson = """
        {
            "content": [\(solutionString)],
            "page": 0,
            "size": 20,
            "totalElements": 1,
            "totalPages": 1
        }
        """.data(using: .utf8)!

        clientSpy.addStub(
            .success(
                (
                    pageJson,
                    HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
                )
            )
        )

        let sut = makeSUT(clientSpy)

        _ = try await sut.listSolutions(
            ListSolutionsQuery(
                courseId: courseId,
                postId: postId,
                page: 0,
                size: 20,
                status: .submitted
            )
        )

        let sentRequest = try #require(clientSpy.getRecordedRequests().first)

        #expect(sentRequest.httpMethod == "GET")

        #expect(
            sentRequest.url?.path ==
            "/api/v1/courses/\(courseId.uuidString)/posts/\(postId.uuidString)/solutions"
        )

        #expect(sentRequest.value(forHTTPHeaderField: "Accept") == "application/json")

        let components = try #require(URLComponents(url: sentRequest.url!, resolvingAgainstBaseURL: false))

        #expect(components.queryItems?.contains(URLQueryItem(name: "status", value: "SUBMITTED")) == true)
        #expect(components.queryItems?.contains(URLQueryItem(name: "page", value: "0")) == true)
        #expect(components.queryItems?.contains(URLQueryItem(name: "size", value: "20")) == true)
    }

    // MARK: - Submit

    @Test("Submit solution sends POST method and maps 409 Conflict properly")
    func submitSolutionRoutingAndConflict() async throws {

        let clientSpy = HTTPClientSpy()

        clientSpy.addStub(
            .success(
                (
                    Data(),
                    HTTPURLResponse(url: anyURL, statusCode: 409, httpVersion: nil, headerFields: nil)!
                )
            )
        )

        let sut = makeSUT(clientSpy)

        await #expect(throws: APIError.serverError(code: 409)) {
            _ = try await sut.submitSolution(
                SubmitSolutionCommand(
                    courseId: courseId,
                    postId: postId,
                    text: "My answer code."
                )
            )
        }

        let sentRequest = try #require(clientSpy.getRecordedRequests().first)

        #expect(sentRequest.httpMethod == "POST")

        #expect(
            sentRequest.url?.absoluteString ==
            "http://localhost:8080/api/v1/courses/\(courseId.uuidString)/posts/\(postId.uuidString)/solutions"
        )

        #expect(sentRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
    }

    // MARK: - Get My Solution

    @Test("Get My Solution accesses the exact /my subpath")
    func getMySolutionRouting() async throws {

        let clientSpy = HTTPClientSpy()

        clientSpy.addStub(
            .success(
                (
                    makeSolutionJSON(),
                    HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
                )
            )
        )

        let sut = makeSUT(clientSpy)

        _ = try await sut.getMySolution(
            GetMySolutionQuery(
                courseId: courseId,
                postId: postId
            )
        )

        let sentRequest = try #require(clientSpy.getRecordedRequests().first)

        #expect(sentRequest.httpMethod == "GET")

        #expect(
            sentRequest.url?.absoluteString ==
            "http://localhost:8080/api/v1/courses/\(courseId.uuidString)/posts/\(postId.uuidString)/solutions/my"
        )
    }

    // MARK: - Update

    @Test("Update solution sends PUT method with payload")
    func updateSolutionRouting() async throws {

        let clientSpy = HTTPClientSpy()

        clientSpy.addStub(
            .success(
                (
                    makeSolutionJSON(),
                    HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
                )
            )
        )

        let sut = makeSUT(clientSpy)

        _ = try await sut.updateSolution(
            UpdateSolutionCommand(
                courseId: courseId,
                postId: postId,
                solutionId: solutionId,
                text: "Updated text"
            )
        )

        let sentRequest = try #require(clientSpy.getRecordedRequests().first)

        #expect(sentRequest.httpMethod == "PUT")

        #expect(
            sentRequest.url?.absoluteString ==
            "http://localhost:8080/api/v1/courses/\(courseId.uuidString)/posts/\(postId.uuidString)/solutions/\(solutionId.uuidString)"
        )

        let bodyData = try #require(sentRequest.httpBody)
        let json = try JSONDecoder().decode(CreateSolutionRequestDTO.self, from: bodyData)

        #expect(json.text == "Updated text")
    }

    // MARK: - Delete

    @Test("Delete solution uses DELETE method")
    func deleteSolutionRouting() async throws {

        let clientSpy = HTTPClientSpy()

        clientSpy.addStub(
            .success(
                (
                    Data(),
                    HTTPURLResponse(url: anyURL, statusCode: 204, httpVersion: nil, headerFields: nil)!
                )
            )
        )

        let sut = makeSUT(clientSpy)

        try await sut.deleteSolution(
            SolutionOfPost(
                courseId: courseId,
                postId: postId,
                solutionId: solutionId
            )
        )

        let sentRequest = try #require(clientSpy.getRecordedRequests().first)

        #expect(sentRequest.httpMethod == "DELETE")

        #expect(
            sentRequest.url?.absoluteString ==
            "http://localhost:8080/api/v1/courses/\(courseId.uuidString)/posts/\(postId.uuidString)/solutions/\(solutionId.uuidString)"
        )
    }
}
