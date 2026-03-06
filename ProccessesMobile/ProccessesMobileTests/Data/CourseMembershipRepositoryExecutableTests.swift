//
//  CourseMembershipRepositoryExecutableTests.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


import Testing
import Foundation
@testable import ProccessesMobile

@Suite("Course Membership Data: Repository Executable Specification")
struct CourseMembershipRepositoryExecutableTests {
    
    let anyURL = URL(string: "http://localhost:8080/api/v1")!
    
    // MARK: - Factory
    
    func makeSUT(client: HTTPClient, baseURL: URL) -> CourseMembershipRepository {
        return MockCourseMembershipRepositoryImpl(client: client, baseURL: baseURL)
    }
    
    // MARK: - JSON Helpers
    
    private func makeCourseJSON() -> Data {
        return """
        {
            "id": "course_123",
            "name": "iOS Dev",
            "description": null,
            "createdAt": "2026-03-06T10:00:00Z",
            "currentUserRole": "STUDENT",
            "teacherCount": 1,
            "studentCount": 5
        }
        """.data(using: .utf8)!
    }
    
    // MARK: - Join Course Tests
    
    @Test("Join course constructs correct URL, sends NO body, and parses Course")
    func joinCourseRouting() async throws {
        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(.success((makeCourseJSON(), HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!)))
        
        let sut = makeSUT(client: clientSpy, baseURL: anyURL)
        
        let result = try await sut.joinCourse(code: "aBcD1234")
        
        #expect(result.id == "course_123")
        #expect(result.name == "iOS Dev")
        #expect(result.currentUserRole == .student)
        
        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)
        
        #expect(sentRequest.url?.absoluteString == "http://localhost:8080/api/v1/invites/aBcD1234/join")
        #expect(sentRequest.httpMethod == "POST")
        
        #expect(sentRequest.httpBody == nil)
    }
    
    @Test("Join course maps 404 (Invite not found) to server error")
    func joinCourseNotFound() async {
        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(.success((Data(), HTTPURLResponse(url: anyURL, statusCode: 404, httpVersion: nil, headerFields: nil)!)))
        
        let sut = makeSUT(client: clientSpy, baseURL: anyURL)
        
        await #expect(throws: APIError.serverError(code: 404)) {
            _ = try await sut.joinCourse(code: "invalid_code")
        }
    }
    
    @Test("Join course maps 409 (Already member) to server error")
    func joinCourseConflict() async {
        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(.success((Data(), HTTPURLResponse(url: anyURL, statusCode: 409, httpVersion: nil, headerFields: nil)!)))
        
        let sut = makeSUT(client: clientSpy, baseURL: anyURL)
        
        await #expect(throws: APIError.serverError(code: 409)) {
            _ = try await sut.joinCourse(code: "aBcD1234")
        }
    }
    
    // MARK: - Leave Course Tests
    
    @Test("Leave course constructs correct URL and Method")
    func leaveCourseRouting() async throws {
        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(.success((Data(), HTTPURLResponse(url: anyURL, statusCode: 204, httpVersion: nil, headerFields: nil)!)))
        
        let sut = makeSUT(client: clientSpy, baseURL: anyURL)
        
        try await sut.leaveCourse(courseId: "course_888")
        
        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)
        
        #expect(sentRequest.url?.absoluteString == "http://localhost:8080/api/v1/courses/course_888/leave")
        #expect(sentRequest.httpMethod == "POST")
        
        #expect(sentRequest.httpBody == nil)
    }
    
    @Test("Leave course handles Unauthorized 401 correctly")
    func leaveCourseUnauthorized() async {
        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(.success((Data(), HTTPURLResponse(url: anyURL, statusCode: 401, httpVersion: nil, headerFields: nil)!)))
        
        let sut = makeSUT(client: clientSpy, baseURL: anyURL)
        
        await #expect(throws: APIError.unauthorized) {
            try await sut.leaveCourse(courseId: "course_123")
        }
    }
}
