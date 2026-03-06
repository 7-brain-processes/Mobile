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
    
    let anyURL = URL(string: "http://localhost:8080/api/v1")!
    
    // MARK: - JSON Helpers
    
    private func makeInviteJSON() -> Data {
        return """
        {
            "id": "inv_123",
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
        return """
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
        clientSpy.addStub(.success((makePageMemberJSON(), HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!)))
        let sut = MockCourseMembersRepositoryImpl(client: clientSpy, baseURL: anyURL)
        
        let _ = try await sut.listMembers(courseId: "c1", page: 1, size: 50, role: CourseRole.teacher)
        
        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)
        
        #expect(sentRequest.httpMethod == "GET")
        #expect(sentRequest.url?.path.contains("/courses/c1/members") == true)
        
        let components = URLComponents(url: sentRequest.url!, resolvingAgainstBaseURL: false)
        #expect(components?.queryItems?.contains(URLQueryItem(name: "page", value: "1")) == true)
        #expect(components?.queryItems?.contains(URLQueryItem(name: "size", value: "50")) == true)
        #expect(components?.queryItems?.contains(URLQueryItem(name: "role", value: "TEACHER")) == true)
    }
    
    @Test("Remove member maps to DELETE method and handles 403 Forbidden")
    func removeMemberRoutingAndForbidden() async throws {
        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(.success((Data(), HTTPURLResponse(url: anyURL, statusCode: 403, httpVersion: nil, headerFields: nil)!)))
        let sut = MockCourseMembersRepositoryImpl(client: clientSpy, baseURL: anyURL)
        
         await #expect(throws: APIError.serverError(code: 403)) {
            try await sut.removeMember(courseId: "c1", userId: "u1")
        }
        
        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)
        #expect(sentRequest.httpMethod == "DELETE")
        #expect(sentRequest.url?.absoluteString == "http://localhost:8080/api/v1/courses/c1/members/u1")
    }
    
    // MARK: - Invites Tests
    
    @Test("Create invite sends POST with correct payload")
    func createInviteRouting() async throws {
        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(.success((makeInviteJSON(), HTTPURLResponse(url: anyURL, statusCode: 201, httpVersion: nil, headerFields: nil)!)))
        let sut = MockCourseInvitesRepositoryImpl(client: clientSpy, baseURL: anyURL)
        
        let _ = try await sut.createInvite(courseId: "c1", request: CreateInviteRequest(role: .student, expiresAt: nil, maxUses: 10))
        
        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)
        
        #expect(sentRequest.httpMethod == "POST")
        #expect(sentRequest.url?.absoluteString == "http://localhost:8080/api/v1/courses/c1/invites")
        
        let bodyData = try #require(sentRequest.httpBody)
        let json = try JSONDecoder().decode(CreateInviteRequest.self, from: bodyData)
        #expect(json.role == .student)
        #expect(json.maxUses == 10)
    }
    
    @Test("List invites maps to GET method and decodes array")
    func listInvitesRouting() async throws {
        let clientSpy = HTTPClientSpy()
        let arrayJSON = "[\(String(data: makeInviteJSON(), encoding: .utf8)!)]".data(using: .utf8)!
        clientSpy.addStub(.success((arrayJSON, HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!)))
        
        let sut = MockCourseInvitesRepositoryImpl(client: clientSpy, baseURL: anyURL)
        let result = try await sut.listInvites(courseId: "c1")
        
        #expect(result.count == 1)
        #expect(result.first?.code == "aBcD1234")
        
        let requests = clientSpy.getRecordedRequests()
        #expect(requests.first?.httpMethod == "GET")
    }
    
    @Test("Revoke invite uses DELETE method")
    func revokeInviteRouting() async throws {
        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(.success((Data(), HTTPURLResponse(url: anyURL, statusCode: 204, httpVersion: nil, headerFields: nil)!)))
        let sut = MockCourseInvitesRepositoryImpl(client: clientSpy, baseURL: anyURL)
        
        try await sut.revokeInvite(courseId: "c1", inviteId: "inv_123")
        
        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)
        #expect(sentRequest.httpMethod == "DELETE")
        #expect(sentRequest.url?.absoluteString == "http://localhost:8080/api/v1/courses/c1/invites/inv_123")
    }
}
