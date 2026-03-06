//
//  CourseDetailsRepositoryExecutableTests.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


import Testing
import Foundation
@testable import ProccessesMobile

@Suite("Course Details Data: Repository Executable Specification")
struct CourseDetailsRepositoryExecutableTests {
    
    let anyURL = URL(string: "http://localhost:8080/api/v1")!
    
    // MARK: - Factory
    
    func makeSUT(client: HTTPClient, baseURL: URL) -> CourseDetailsRepository {
        return MockCourseDetailsRepositoryImpl(client: client, baseURL: baseURL)
    }
    
    // MARK: - JSON Helpers
    
    private func makeCourseJSON() -> Data {
        return """
        {
            "id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
            "name": "Data Structures",
            "description": "Advanced topics",
            "createdAt": "2026-03-06T10:00:00Z",
            "currentUserRole": "TEACHER",
            "teacherCount": 1,
            "studentCount": 10
        }
        """.data(using: .utf8)!
    }
    
    // MARK: - Get Course Tests
    
    @Test("Get course constructs correct URL and parses JSON")
    func getCourseRoutingAndParsing() async throws {
        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(.success((makeCourseJSON(), HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!)))
        let sut = makeSUT(client: clientSpy, baseURL: anyURL)
        
        let result = try await sut.getCourse(courseId: "course_123")
        
        #expect(result.id == "7c9e6679-7425-40de-944b-e07fc1f90ae7")
        #expect(result.name == "Data Structures")
        #expect(result.currentUserRole == .teacher)
        
        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)
        #expect(sentRequest.httpMethod == "GET")
        #expect(sentRequest.url?.absoluteString == "http://localhost:8080/api/v1/courses/course_123")
    }
    
    @Test("Get course maps 404 HTTP to Domain Error")
    func getCourseNotFound() async {
        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(.success((Data(), HTTPURLResponse(url: anyURL, statusCode: 404, httpVersion: nil, headerFields: nil)!)))
        let sut = makeSUT(client: clientSpy, baseURL: anyURL)
        
        await #expect(throws: APIError.serverError(code: 404)) {
            try await sut.getCourse(courseId: "missing")
        }
    }
    
    // MARK: - Update Course Tests
    
    @Test("Update course sends JSON body with PUT method")
    func updateCourseRouting() async throws {
        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(.success((makeCourseJSON(), HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!)))
        let sut = makeSUT(client: clientSpy, baseURL: anyURL)
        
        let updateRequest = UpdateCourseRequest(name: "New Name", description: "New Desc")
        _ = try await sut.updateCourse(courseId: "course_456", request: updateRequest)
        
        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)
        
        #expect(sentRequest.httpMethod == "PUT")
        #expect(sentRequest.url?.absoluteString == "http://localhost:8080/api/v1/courses/course_456")
        #expect(sentRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        
        let bodyData = try #require(sentRequest.httpBody)
        let json = try JSONDecoder().decode(UpdateCourseRequest.self, from: bodyData)
        #expect(json.name == "New Name")
        #expect(json.description == "New Desc")
    }
    
    @Test("Update course maps 403 Forbidden HTTP to Domain Error")
    func updateCourseForbidden() async {
        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(.success((Data(), HTTPURLResponse(url: anyURL, statusCode: 403, httpVersion: nil, headerFields: nil)!)))
        let sut = makeSUT(client: clientSpy, baseURL: anyURL)
        
        await #expect(throws: APIError.serverError(code: 403)) {
            try await sut.updateCourse(courseId: "course_456", request: UpdateCourseRequest(name: "Test", description: nil))
        }
    }
    
    // MARK: - Delete Course Tests
    
    @Test("Delete course uses DELETE method and exact path")
    func deleteCourseRouting() async throws {
        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(.success((Data(), HTTPURLResponse(url: anyURL, statusCode: 204, httpVersion: nil, headerFields: nil)!)))
        let sut = makeSUT(client: clientSpy, baseURL: anyURL)
        
        try await sut.deleteCourse(courseId: "course_999")
        
        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)
        
        #expect(sentRequest.httpMethod == "DELETE")
        #expect(sentRequest.url?.absoluteString == "http://localhost:8080/api/v1/courses/course_999")
        #expect(sentRequest.httpBody == nil)
    }
}
