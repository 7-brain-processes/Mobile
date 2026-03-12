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
    let courseId = UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!
    let postId = UUID(uuidString: "550e8400-e29b-41d4-a716-446655440002")!
    let solutionId = UUID(uuidString: "550e8400-e29b-41d4-a716-446655440003")!

    func makeSUT(client: HTTPClient, baseURL: URL) -> SolutionRepository {
        MockSolutionRepositoryImpl(client: client, baseURL: baseURL)
    }

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

        let sut = makeSUT(client: clientSpy, baseURL: anyURL)

        _ = try await sut.listSolutions(
            ListSolutionsQuery(
                courseId: courseId,
                postId: postId,
                page: 0,
                size: 20,
                status: .submitted
            )
        )

        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)

        #expect(sentRequest.httpMethod == "GET")

        #expect(
            sentRequest.url?.path
                == "/api/v1/courses/\(courseId.uuidString)/posts/\(postId.uuidString)/solutions"
        )

        let url = try #require(sentRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))

        #expect(components.queryItems?.contains(URLQueryItem(name: "status", value: "SUBMITTED")) == true)
        #expect(components.queryItems?.contains(URLQueryItem(name: "page", value: "0")) == true)
        #expect(components.queryItems?.contains(URLQueryItem(name: "size", value: "20")) == true)
    }

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

        let sut = makeSUT(client: clientSpy, baseURL: anyURL)

        await #expect(throws: APIError.serverError(code: 409)) {
            _ = try await sut.submitSolution(
                SubmitSolutionCommand(
                    courseId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!,
                    postId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440002")!,
                    text: "My answer code."
                )
            )
        }

        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)
        #expect(sentRequest.httpMethod == "POST")
        #expect(
            sentRequest.url?.absoluteString
                == "http://localhost:8080/api/v1/courses/\(courseId.uuidString)/posts/\(postId.uuidString)/solutions"
        )
    }

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

        let sut = makeSUT(client: clientSpy, baseURL: anyURL)

        _ = try await sut.getMySolution(
            GetMySolutionQuery(
                courseId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!,
                postId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440002")!
            )
        )

        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)
        #expect(sentRequest.httpMethod == "GET")
        #expect(
            sentRequest.url?.absoluteString
            == "http://localhost:8080/api/v1/courses/\(courseId.uuidString)/posts/\(postId.uuidString)/solutions/my"
        )
    }

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

        let sut = makeSUT(client: clientSpy, baseURL: anyURL)

        _ = try await sut.updateSolution(
            UpdateSolutionCommand(
                courseId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!,
                postId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440002")!,
                solutionId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440003")!,
                text: "Updated text"
            )
        )

        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)

        #expect(sentRequest.httpMethod == "PUT")
        #expect(
            sentRequest.url?.absoluteString
                == "http://localhost:8080/api/v1/courses/\(courseId.uuidString)/posts/\(postId.uuidString)/solutions/\(solutionId.uuidString)"
        )

        let bodyData = try #require(sentRequest.httpBody)
        let json = try JSONDecoder().decode(CreateSolutionRequestDTO.self, from: bodyData)
        #expect(json.text == "Updated text")
    }

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

        let sut = makeSUT(client: clientSpy, baseURL: anyURL)

        try await sut.deleteSolution(
            SolutionOfPost(
                courseId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!,
                postId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440002")!,
                solutionId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440003")!
            )
        )

        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)
        #expect(sentRequest.httpMethod == "DELETE")
        #expect(
            sentRequest.url?.absoluteString
                == "http://localhost:8080/api/v1/courses/\(courseId.uuidString)/posts/\(postId.uuidString)/solutions/\(solutionId.uuidString)"
        )
    }
}
