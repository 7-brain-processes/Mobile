//
//  PostRepositoryExecutableTests.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


import Testing
import Foundation
@testable import ProccessesMobile

@Suite("Posts Data: Repository Executable Specification")
struct PostRepositoryExecutableTests {
    
    let anyURL = URL(string: "http://localhost:8080/api/v1")!
    
    func makeSUT(client: HTTPClient, baseURL: URL) -> PostRepository {
        return MockPostRepositoryImpl(client: client, baseURL: baseURL)
    }
    
    private func makePostJSON() -> Data {
        return """
        {
            "id": "post_1",
            "title": "Assignment 1",
            "content": "Please complete by Friday.",
            "type": "TASK",
            "deadline": "2026-03-10T12:00:00Z",
            "author": null,
            "materialsCount": 2,
            "commentsCount": 0,
            "solutionsCount": 0,
            "mySolutionId": null,
            "createdAt": "2026-03-06T10:00:00Z",
            "updatedAt": "2026-03-06T10:00:00Z"
        }
        """.data(using: .utf8)!
    }
    
    @Test("List posts constructs correct URL and query parameters")
    func listPostsRouting() async throws {
        let clientSpy = HTTPClientSpy()
        let pageJson = """
        { "content": [\(String(data: makePostJSON(), encoding: .utf8)!)], "page": 2, "size": 10, "totalElements": 1, "totalPages": 1 }
        """.data(using: .utf8)!
        
        clientSpy.addStub(.success((pageJson, HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!)))
        let sut = makeSUT(client: clientSpy, baseURL: anyURL)
        
        let _ = try await sut.listPosts(courseId: "c1", page: 2, size: 10, type: .task)
        
        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)
        
        #expect(sentRequest.httpMethod == "GET")
        #expect(sentRequest.url?.path.contains("/courses/c1/posts") == true)
        
        let components = URLComponents(url: sentRequest.url!, resolvingAgainstBaseURL: false)
        #expect(components?.queryItems?.contains(URLQueryItem(name: "page", value: "2")) == true)
        #expect(components?.queryItems?.contains(URLQueryItem(name: "type", value: "TASK")) == true)
    }
    
    @Test("Create post sends POST method with JSON payload")
    func createPostRouting() async throws {
        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(.success((makePostJSON(), HTTPURLResponse(url: anyURL, statusCode: 201, httpVersion: nil, headerFields: nil)!)))
        let sut = makeSUT(client: clientSpy, baseURL: anyURL)
        
        let reqBody = CreatePostRequest(title: "Assignment 1", type: .task)
        let _ = try await sut.createPost(courseId: "c1", request: reqBody)
        
        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)
        
        #expect(sentRequest.httpMethod == "POST")
        #expect(sentRequest.url?.absoluteString == "http://localhost:8080/api/v1/courses/c1/posts")
        
        let bodyData = try #require(sentRequest.httpBody)
        let sentJSON = try JSONDecoder().decode(CreatePostRequest.self, from: bodyData)
        #expect(sentJSON.title == "Assignment 1")
    }
    
    @Test("Delete post sends DELETE method and maps 403 properly")
    func deletePostRouting() async throws {
        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(.success((Data(), HTTPURLResponse(url: anyURL, statusCode: 403, httpVersion: nil, headerFields: nil)!)))
        let sut = makeSUT(client: clientSpy, baseURL: anyURL)
        
        await #expect(throws: APIError.serverError(code: 403)) {
            try await sut.deletePost(courseId: "c1", postId: "p1")
        }
        
        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)
        #expect(sentRequest.httpMethod == "DELETE")
        #expect(sentRequest.url?.absoluteString == "http://localhost:8080/api/v1/courses/c1/posts/p1")
    }
}