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
    let anyURL = URL(string: "http://localhost:8080/api/v1")!
    
    private func makeCommentJSON() -> Data {
        return """
        {
            "id": "com_789",
            "text": "Great logic here!",
            "author": null,
            "createdAt": "2026-03-06T10:00:00Z",
            "updatedAt": "2026-03-06T10:00:00Z"
        }
        """.data(using: .utf8)!
    }
    
    @Test("Create solution comment routes correctly and sends POST JSON")
    func createRouting() async throws {
        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(.success((makeCommentJSON(), HTTPURLResponse(url: anyURL, statusCode: 201, httpVersion: nil, headerFields: nil)!)))
        let sut = MockSolutionCommentsRepositoryImpl(client: clientSpy, baseURL: anyURL)
        
        let reqBody = CreateCommentRequest(text: "Great logic here!")
        let result = try await sut.createComment(courseId: "c1", postId: "p1", solutionId: "s1", request: reqBody)
        
        #expect(result.id == "com_789")
        
        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)
        
        #expect(sentRequest.httpMethod == "POST")
        #expect(sentRequest.url?.absoluteString == "http://localhost:8080/api/v1/courses/c1/posts/p1/solutions/s1/comments")
        
        let sentBody = try JSONDecoder().decode(CreateCommentRequest.self, from: try #require(sentRequest.httpBody))
        #expect(sentBody.text == "Great logic here!")
    }
    
    @Test("Update solution comment uses PUT to specific comment ID")
    func updateRouting() async throws {
        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(.success((makeCommentJSON(), HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!)))
        let sut = MockSolutionCommentsRepositoryImpl(client: clientSpy, baseURL: anyURL)
        
        _ = try await sut.updateComment(courseId: "c1", postId: "p1", solutionId: "s1", commentId: "com_789", request: CreateCommentRequest(text: "Edit"))
        
        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)
        
        #expect(sentRequest.httpMethod == "PUT")
        #expect(sentRequest.url?.absoluteString == "http://localhost:8080/api/v1/courses/c1/posts/p1/solutions/s1/comments/com_789")
    }
    
    @Test("Delete solution comment uses DELETE method")
    func deleteRouting() async throws {
        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(.success((Data(), HTTPURLResponse(url: anyURL, statusCode: 204, httpVersion: nil, headerFields: nil)!)))
        let sut = MockSolutionCommentsRepositoryImpl(client: clientSpy, baseURL: anyURL)
        
        try await sut.deleteComment(courseId: "c1", postId: "p1", solutionId: "s1", commentId: "com_789")
        
        let requests = clientSpy.getRecordedRequests()
        #expect(requests.first?.httpMethod == "DELETE")
    }
}