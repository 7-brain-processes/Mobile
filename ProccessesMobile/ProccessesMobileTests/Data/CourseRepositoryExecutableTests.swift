//
//  CourseRepositoryExecutableTests.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Testing
import Foundation
@testable import ProccessesMobile

@Suite("Courses Data: Repository Executable Specification")
struct CourseRepositoryExecutableTests {

    private let anyURL = URL(string: "http://localhost:8080/api/v1")!

    private func makeSUT(client: HTTPClient, baseURL: URL) -> CourseRepository {
        let apiClient = APIClient(
            httpClient: client,
            configuration: APIConfiguration(baseURL: baseURL)
        )

        return DefaultCourseRepository(apiClient: apiClient)
    }

    // MARK: - JSON Builders

    private func makePageCourseJSON() -> Data {
        """
        {
            "content": [
                {
                    "id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
                    "name": "Data Structures",
                    "description": "Spring 2026",
                    "createdAt": "2026-03-06T10:00:00Z",
                    "currentUserRole": "TEACHER",
                    "teacherCount": 2,
                    "studentCount": 30
                }
            ],
            "page": 0,
            "size": 20,
            "totalElements": 1,
            "totalPages": 1
        }
        """.data(using: .utf8)!
    }

    private func makeSingleCourseJSON() -> Data {
        """
        {
            "id": "11111111-2222-3333-4444-555555555555",
            "name": "New Course",
            "description": null,
            "createdAt": "2026-03-06T12:00:00Z",
            "currentUserRole": "TEACHER",
            "teacherCount": 1,
            "studentCount": 0
        }
        """.data(using: .utf8)!
    }

    // MARK: - GET Courses Tests

    @Test("Get courses constructs correct URL with query parameters")
    func getCoursesRouting() async throws {
        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(
            .success(
                (
                    makePageCourseJSON(),
                    HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
                )
            )
        )

        let sut = makeSUT(client: clientSpy, baseURL: anyURL)

        let result = try await sut.getMyCourses(
            GetMyCoursesQuery(
                page: 2,
                size: 50,
                role: .student
            )
        )

        #expect(result.content.count == 1)
        #expect(result.content[0].name == "Data Structures")
        #expect(result.content[0].currentUserRole == .teacher)

        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)
        let requestURL = try #require(sentRequest.url)
        let components = try #require(URLComponents(url: requestURL, resolvingAgainstBaseURL: false))

        #expect(sentRequest.httpMethod == "GET")
        #expect(requestURL.path.contains("/courses"))
        #expect(sentRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(components.queryItems?.contains(URLQueryItem(name: "page", value: "2")) == true)
        #expect(components.queryItems?.contains(URLQueryItem(name: "size", value: "50")) == true)
        #expect(components.queryItems?.contains(URLQueryItem(name: "role", value: "STUDENT")) == true)
    }

    @Test("Get courses propagates 401 Unauthorized")
    func getCoursesUnauthorized() async {
        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(
            .success(
                (
                    Data(),
                    HTTPURLResponse(url: anyURL, statusCode: 401, httpVersion: nil, headerFields: nil)!
                )
            )
        )

        let sut = makeSUT(client: clientSpy, baseURL: anyURL)

        await #expect(throws: APIError.unauthorized) {
            _ = try await sut.getMyCourses(
                GetMyCoursesQuery(
                    page: 0,
                    size: 20,
                    role: nil
                )
            )
        }
    }

    // MARK: - POST Courses Tests

    @Test("Create course sends JSON body and parses 201 Created")
    func createCourseRoutingAndParsing() async throws {
        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(
            .success(
                (
                    makeSingleCourseJSON(),
                    HTTPURLResponse(url: anyURL, statusCode: 201, httpVersion: nil, headerFields: nil)!
                )
            )
        )

        let sut = makeSUT(client: clientSpy, baseURL: anyURL)

        let command = CreateCourseCommand(
            name: "New Course",
            description: nil
        )

        let result = try await sut.createCourse(command)

        #expect(result.id == UUID(uuidString: "11111111-2222-3333-4444-555555555555"))
        #expect(result.name == "New Course")
        #expect(result.description == nil)

        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)

        #expect(sentRequest.httpMethod == "POST")
        #expect(sentRequest.url?.path.contains("/courses") == true)
        #expect(sentRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(sentRequest.value(forHTTPHeaderField: "Accept") == "application/json")

        let bodyData = try #require(sentRequest.httpBody)
        let sentBody = try JSONDecoder().decode(
            CreateCourseRequestDTO.self,
            from: bodyData
        )

        #expect(sentBody.name == "New Course")
        #expect(sentBody.description == nil)
    }
}
