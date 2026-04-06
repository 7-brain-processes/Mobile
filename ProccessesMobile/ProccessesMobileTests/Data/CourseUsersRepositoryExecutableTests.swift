//
//  CourseUsersRepositoryExecutableTests.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Testing
import Foundation
@testable import ProccessesMobile

@Suite("Course Users Data: Repository Executable Specification")
struct CourseUsersRepositoryExecutableTests {

    private let anyURL = URL(string: "http://localhost:8080/api/v1")!

    private let courseId = UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!
    private let userId = UUID(uuidString: "550e8400-e29b-41d4-a716-446655440002")!
    private let inviteId = UUID(uuidString: "550e8400-e29b-41d4-a716-446655440123")!

    // MARK: - Factory

    private func makeAPIClient(_ client: HTTPClient) -> APIClient {
        APIClient(
            httpClient: client,
            configuration: APIConfiguration(baseURL: anyURL)
        )
    }

    // MARK: - JSON Helpers

    private func makeInviteJSON() -> Data {
        """
        {
            "id": "550e8400-e29b-41d4-a716-446655440123",
            "code": "aBcD1234",
            "role": "STUDENT",
            "expiresAt": null,
            "maxUses": 10,
            "currentUses": 2,
            "createdAt": "2026-03-06T10:00:00Z"
        }
        """.data(using: .utf8)!
    }

    private func makePageMemberJSON() -> Data {
        """
        {
            "content": [
                {
                    "user": null,
                    "role": "STUDENT",
                    "joinedAt": "2026-03-06T10:00:00Z"
                }
            ],
            "page": 0,
            "size": 20,
            "totalElements": 1,
            "totalPages": 1
        }
        """.data(using: .utf8)!
    }

    // MARK: - Members Tests

    @Test("List members constructs correct URL and query params")
    func listMembersRouting() async throws {

        let clientSpy = HTTPClientSpy()

        clientSpy.addStub(
            .success(
                (
                    makePageMemberJSON(),
                    HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
                )
            )
        )

        let sut = DefaultCourseMembersRepository(
            apiClient: makeAPIClient(clientSpy)
        )

        _ = try await sut.listMembers(
            ListMembersQuery(
                courseId: courseId,
                page: 1,
                size: 50,
                role: .teacher
            )
        )

        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)

        #expect(sentRequest.httpMethod == "GET")

        #expect(
            sentRequest.url?.path ==
            "/api/v1/courses/\(courseId.uuidString)/members"
        )

        #expect(sentRequest.value(forHTTPHeaderField: "Accept") == "application/json")

        let url = try #require(sentRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))

        #expect(components.queryItems?.contains(URLQueryItem(name: "page", value: "1")) == true)
        #expect(components.queryItems?.contains(URLQueryItem(name: "size", value: "50")) == true)
        #expect(components.queryItems?.contains(URLQueryItem(name: "role", value: "TEACHER")) == true)
    }

    @Test("Remove member maps to DELETE method and handles 403 Forbidden")
    func removeMemberRoutingAndForbidden() async throws {

        let clientSpy = HTTPClientSpy()

        clientSpy.addStub(
            .success(
                (
                    Data(),
                    HTTPURLResponse(url: anyURL, statusCode: 403, httpVersion: nil, headerFields: nil)!
                )
            )
        )

        let sut = DefaultCourseMembersRepository(
            apiClient: makeAPIClient(clientSpy)
        )

        await #expect(throws: APIError.serverError(code: 403)) {
            try await sut.removeMember(
                RemoveMemberCommand(
                    courseId: courseId,
                    userId: userId
                )
            )
        }

        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)

        #expect(sentRequest.httpMethod == "DELETE")

        #expect(
            sentRequest.url?.absoluteString ==
            "http://localhost:8080/api/v1/courses/\(courseId.uuidString)/members/\(userId.uuidString)"
        )
    }

    // MARK: - Invites Tests

    @Test("Create invite sends POST with correct payload")
    func createInviteRouting() async throws {

        let clientSpy = HTTPClientSpy()

        clientSpy.addStub(
            .success(
                (
                    makeInviteJSON(),
                    HTTPURLResponse(url: anyURL, statusCode: 201, httpVersion: nil, headerFields: nil)!
                )
            )
        )

        let sut = DefaultCourseInvitesRepository(
            apiClient: makeAPIClient(clientSpy)
        )

        _ = try await sut.createInvite(
            CreateInviteCommand(
                courseId: courseId,
                role: .student,
                expiresAt: nil,
                maxUses: 10
            )
        )

        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)

        #expect(sentRequest.httpMethod == "POST")

        #expect(
            sentRequest.url?.absoluteString ==
            "http://localhost:8080/api/v1/courses/\(courseId.uuidString)/invites"
        )

        #expect(sentRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(sentRequest.value(forHTTPHeaderField: "Accept") == "application/json")

        let bodyData = try #require(sentRequest.httpBody)
        let json = try JSONDecoder().decode(CreateInviteRequestDTO.self, from: bodyData)

        #expect(json.role == .student)
        #expect(json.maxUses == 10)
    }

    @Test("List invites maps to GET method and decodes array")
    func listInvitesRouting() async throws {

        let clientSpy = HTTPClientSpy()

        let inviteString = try #require(String(data: makeInviteJSON(), encoding: .utf8))
        let arrayJSON = "[\(inviteString)]".data(using: .utf8)!

        clientSpy.addStub(
            .success(
                (
                    arrayJSON,
                    HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
                )
            )
        )

        let sut = DefaultCourseInvitesRepository(
            apiClient: makeAPIClient(clientSpy)
        )

        let result = try await sut.listInvites(
            courseId: courseId
        )

        #expect(result.count == 1)
        #expect(result.first?.code == "aBcD1234")

        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)

        #expect(sentRequest.httpMethod == "GET")
        #expect(sentRequest.value(forHTTPHeaderField: "Accept") == "application/json")
    }

    @Test("Revoke invite uses DELETE method")
    func revokeInviteRouting() async throws {

        let clientSpy = HTTPClientSpy()

        clientSpy.addStub(
            .success(
                (
                    Data(),
                    HTTPURLResponse(url: anyURL, statusCode: 204, httpVersion: nil, headerFields: nil)!
                )
            )
        )

        let sut = DefaultCourseInvitesRepository(
            apiClient: makeAPIClient(clientSpy)
        )

        try await sut.revokeInvite(
            RevokeInviteCommand(
                courseId: courseId,
                inviteId: inviteId
            )
        )

        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)

        #expect(sentRequest.httpMethod == "DELETE")

        #expect(
            sentRequest.url?.absoluteString ==
            "http://localhost:8080/api/v1/courses/\(courseId.uuidString)/invites/\(inviteId.uuidString)"
        )
    }
}
