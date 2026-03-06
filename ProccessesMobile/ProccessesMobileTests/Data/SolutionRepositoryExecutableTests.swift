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
    
    let anyURL = URL(string: "http://localhost:8080/api/v1")!
    
    func makeSUT(client: HTTPClient, baseURL: URL) -> SolutionRepository {
        return MockSolutionRepositoryImpl(client: client, baseURL: baseURL)
    }
    
    private func makeSolutionJSON() -> Data {
        return """
        {
            "id": "sol_1",
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
        let pageJson = """
        { "content": [\(String(data: makeSolutionJSON(), encoding: .utf8)!)], "page": 0, "size": 20, "totalElements": 1, "totalPages": 1 }
        """.data(using: .utf8)!
        
        clientSpy.addStub(.success((pageJson, HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!)))
        let sut = makeSUT(client: clientSpy, baseURL: anyURL)
        
        let _ = try await sut.listSolutions(courseId: "c1", postId: "p1", page: 0, size: 20, status: .submitted)
        
        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)
        
        #expect(sentRequest.httpMethod == "GET")
        #expect(sentRequest.url?.path.contains("/courses/c1/posts/p1/solutions") == true)
        
        let components = URLComponents(url: sentRequest.url!, resolvingAgainstBaseURL: false)
        #expect(components?.queryItems?.contains(URLQueryItem(name: "status", value: "SUBMITTED")) == true)
    }
    
    @Test("Submit solution sends POST method and maps 409 Conflict properly")
    func submitSolutionRoutingAndConflict() async throws {
        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(.success((Data(), HTTPURLResponse(url: anyURL, statusCode: 409, httpVersion: nil, headerFields: nil)!)))
        let sut = makeSUT(client: clientSpy, baseURL: anyURL)
        
        let reqBody = CreateSolutionRequest(text: "My answer code.")
        
        await #expect(throws: APIError.serverError(code: 409)) {
            _ = try await sut.submitSolution(courseId: "c1", postId: "p1", request: reqBody)
        }
        
        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)
        #expect(sentRequest.httpMethod == "POST")
        #expect(sentRequest.url?.absoluteString == "http://localhost:8080/api/v1/courses/c1/posts/p1/solutions")
    }
    
    @Test("Get My Solution accesses the exact /my subpath")
    func getMySolutionRouting() async throws {
        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(.success((makeSolutionJSON(), HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!)))
        let sut = makeSUT(client: clientSpy, baseURL: anyURL)
        
        let _ = try await sut.getMySolution(courseId: "c1", postId: "p1")
        
        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)
        #expect(sentRequest.httpMethod == "GET")
        #expect(sentRequest.url?.absoluteString == "http://localhost:8080/api/v1/courses/c1/posts/p1/solutions/my")
    }
    
    @Test("Update solution sends PUT method with payload")
    func updateSolutionRouting() async throws {
        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(.success((makeSolutionJSON(), HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!)))
        let sut = makeSUT(client: clientSpy, baseURL: anyURL)
        
        let _ = try await sut.updateSolution(courseId: "c1", postId: "p1", solutionId: "s1", request: CreateSolutionRequest(text: "Updated text"))
        
        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)
        
        #expect(sentRequest.httpMethod == "PUT")
        #expect(sentRequest.url?.absoluteString == "http://localhost:8080/api/v1/courses/c1/posts/p1/solutions/s1")
        
        let bodyData = try #require(sentRequest.httpBody)
        let json = try JSONDecoder().decode(CreateSolutionRequest.self, from: bodyData)
        #expect(json.text == "Updated text")
    }
    
    @Test("Delete solution uses DELETE method")
    func deleteSolutionRouting() async throws {
        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(.success((Data(), HTTPURLResponse(url: anyURL, statusCode: 204, httpVersion: nil, headerFields: nil)!)))
        let sut = makeSUT(client: clientSpy, baseURL: anyURL)
        
        try await sut.deleteSolution(courseId: "c1", postId: "p1", solutionId: "s1")
        
        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)
        #expect(sentRequest.httpMethod == "DELETE")
    }
}
