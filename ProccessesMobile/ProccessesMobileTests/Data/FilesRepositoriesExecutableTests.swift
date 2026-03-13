//
//  FilesRepositoriesExecutableTests.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Testing
import Foundation
@testable import ProccessesMobile

@Suite("File Attachments Data: Repository Executable Specification")
struct FilesRepositoriesExecutableTests {

    private let anyURL = URL(string: "http://localhost:8080/api/v1")!

    private let courseId = UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!
    private let postId = UUID(uuidString: "550e8400-e29b-41d4-a716-446655440002")!
    private let solutionId = UUID(uuidString: "550e8400-e29b-41d4-a716-446655440003")!
    private let fileId = UUID(uuidString: "550e8400-e29b-41d4-a716-446655440123")!

    // MARK: - Factory

    private func makeAPIClient(_ client: HTTPClient) -> APIClient {
        APIClient(
            httpClient: client,
            configuration: APIConfiguration(baseURL: anyURL)
        )
    }

    // MARK: - JSON Builders

    private func makeFileJSON() -> Data {
        """
        {
            "id": "550e8400-e29b-41d4-a716-446655440123",
            "originalName": "lecture_03.pdf",
            "contentType": "application/pdf",
            "sizeBytes": 204800,
            "uploadedAt": "2026-03-06T10:00:00Z"
        }
        """.data(using: .utf8)!
    }

    private func makeFileListJSON() -> Data {
        """
        [
            {
                "id": "550e8400-e29b-41d4-a716-446655440123",
                "originalName": "lecture_03.pdf",
                "contentType": "application/pdf",
                "sizeBytes": 204800,
                "uploadedAt": "2026-03-06T10:00:00Z"
            }
        ]
        """.data(using: .utf8)!
    }

    // MARK: - Post Materials

    @Test("Upload material uses multipart/form-data and POST method")
    func uploadMaterialRouting() async throws {

        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(
            .success(
                (
                    makeFileJSON(),
                    HTTPURLResponse(url: anyURL, statusCode: 201, httpVersion: nil, headerFields: nil)!
                )
            )
        )

        let sut = DefaultPostMaterialsRepository(
            apiClient: makeAPIClient(clientSpy)
        )

        let fileData = "fake_pdf_binary".data(using: .utf8)!

        let result = try await sut.uploadMaterial(
            UploadPostMaterialCommand(
                courseId: courseId,
                postId: postId,
                fileName: "lecture_03.pdf",
                mimeType: "application/pdf",
                data: fileData
            )
        )

        #expect(result.id == fileId)
        #expect(result.sizeBytes == 204800)

        let sentRequest = try #require(clientSpy.getRecordedRequests().first)

        #expect(sentRequest.httpMethod == "POST")

        #expect(
            sentRequest.url?.absoluteString ==
            "http://localhost:8080/api/v1/courses/\(courseId.uuidString)/posts/\(postId.uuidString)/materials"
        )

        let contentType = try #require(sentRequest.value(forHTTPHeaderField: "Content-Type"))
        #expect(contentType.contains("multipart/form-data"))
        #expect(contentType.contains("boundary="))

        let body = try #require(sentRequest.httpBody)
        let bodyString = String(data: body, encoding: .utf8) ?? ""

        #expect(bodyString.contains("filename=\"lecture_03.pdf\""))
        #expect(bodyString.contains("fake_pdf_binary"))
    }

    @Test("Upload material maps 413 File Too Large correctly")
    func uploadMaterialFileTooLarge() async {

        let clientSpy = HTTPClientSpy()

        clientSpy.addStub(
            .success(
                (
                    Data(),
                    HTTPURLResponse(url: anyURL, statusCode: 413, httpVersion: nil, headerFields: nil)!
                )
            )
        )

        let sut = DefaultPostMaterialsRepository(
            apiClient: makeAPIClient(clientSpy)
        )

        await #expect(throws: APIError.serverError(code: 413)) {
            _ = try await sut.uploadMaterial(
                UploadPostMaterialCommand(
                    courseId: courseId,
                    postId: postId,
                    fileName: "huge.mp4",
                    mimeType: "video/mp4",
                    data: Data(repeating: 1, count: 10)
                )
            )
        }
    }

    @Test("List post materials routes to correct GET path")
    func listPostMaterialsRouting() async throws {

        let clientSpy = HTTPClientSpy()

        clientSpy.addStub(
            .success(
                (
                    makeFileListJSON(),
                    HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
                )
            )
        )

        let sut = DefaultPostMaterialsRepository(
            apiClient: makeAPIClient(clientSpy)
        )

        let result = try await sut.listMaterials(
            ListPostMaterialsQuery(
                courseId: courseId,
                postId: postId
            )
        )

        #expect(result.count == 1)
        #expect(result.first?.id == fileId)

        let sentRequest = try #require(clientSpy.getRecordedRequests().first)

        #expect(sentRequest.httpMethod == "GET")

        #expect(
            sentRequest.url?.absoluteString ==
            "http://localhost:8080/api/v1/courses/\(courseId.uuidString)/posts/\(postId.uuidString)/materials"
        )

        #expect(sentRequest.value(forHTTPHeaderField: "Accept") == "application/json")
    }

    @Test("Delete post material routes to correct DELETE path")
    func deletePostMaterialRouting() async throws {

        let clientSpy = HTTPClientSpy()

        clientSpy.addStub(
            .success(
                (
                    Data(),
                    HTTPURLResponse(url: anyURL, statusCode: 204, httpVersion: nil, headerFields: nil)!
                )
            )
        )

        let sut = DefaultPostMaterialsRepository(
            apiClient: makeAPIClient(clientSpy)
        )

        try await sut.deleteMaterial(
            DeletePostMaterialCommand(
                courseId: courseId,
                postId: postId,
                fileId: fileId
            )
        )

        let sentRequest = try #require(clientSpy.getRecordedRequests().first)

        #expect(sentRequest.httpMethod == "DELETE")

        #expect(
            sentRequest.url?.absoluteString ==
            "http://localhost:8080/api/v1/courses/\(courseId.uuidString)/posts/\(postId.uuidString)/materials/\(fileId.uuidString)"
        )
    }

    @Test("Download post material routes to /download and returns binary data")
    func downloadPostMaterialRouting() async throws {

        let clientSpy = HTTPClientSpy()

        let binaryData = "raw_post_material_bytes".data(using: .utf8)!

        clientSpy.addStub(
            .success(
                (
                    binaryData,
                    HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
                )
            )
        )

        let sut = DefaultPostMaterialsRepository(
            apiClient: makeAPIClient(clientSpy)
        )

        let result = try await sut.downloadMaterial(
            DownloadPostMaterialQuery(
                courseId: courseId,
                postId: postId,
                fileId: fileId
            )
        )

        #expect(result == binaryData)

        let sentRequest = try #require(clientSpy.getRecordedRequests().first)

        #expect(sentRequest.httpMethod == "GET")

        #expect(
            sentRequest.url?.absoluteString ==
            "http://localhost:8080/api/v1/courses/\(courseId.uuidString)/posts/\(postId.uuidString)/materials/\(fileId.uuidString)/download"
        )
    }

    // MARK: - Solution Files

    @Test("Upload solution file routes to correct subpath")
    func uploadSolutionFileRouting() async throws {

        let clientSpy = HTTPClientSpy()

        clientSpy.addStub(
            .success(
                (
                    makeFileJSON(),
                    HTTPURLResponse(url: anyURL, statusCode: 201, httpVersion: nil, headerFields: nil)!
                )
            )
        )

        let sut = DefaultSolutionFilesRepository(
            apiClient: makeAPIClient(clientSpy)
        )

        _ = try await sut.uploadSolutionFile(
            UploadSolutionFileCommand(
                courseId: courseId,
                postId: postId,
                solutionId: solutionId,
                fileName: "homework.zip",
                mimeType: "application/zip",
                data: Data()
            )
        )

        let sentRequest = try #require(clientSpy.getRecordedRequests().first)

        #expect(sentRequest.httpMethod == "POST")

        #expect(
            sentRequest.url?.absoluteString ==
            "http://localhost:8080/api/v1/courses/\(courseId.uuidString)/posts/\(postId.uuidString)/solutions/\(solutionId.uuidString)/files"
        )
    }

    @Test("List solution files routes to correct GET path")
    func listSolutionFilesRouting() async throws {

        let clientSpy = HTTPClientSpy()

        clientSpy.addStub(
            .success(
                (
                    makeFileListJSON(),
                    HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
                )
            )
        )

        let sut = DefaultSolutionFilesRepository(
            apiClient: makeAPIClient(clientSpy)
        )

        let result = try await sut.listSolutionFiles(
            ListSolutionFilesQuery(
                courseId: courseId,
                postId: postId,
                solutionId: solutionId
            )
        )

        #expect(result.count == 1)
        #expect(result.first?.id == fileId)

        let sentRequest = try #require(clientSpy.getRecordedRequests().first)

        #expect(sentRequest.httpMethod == "GET")

        #expect(
            sentRequest.url?.absoluteString ==
            "http://localhost:8080/api/v1/courses/\(courseId.uuidString)/posts/\(postId.uuidString)/solutions/\(solutionId.uuidString)/files"
        )
    }

    @Test("Delete solution file routes to correct DELETE path")
    func deleteSolutionFileRouting() async throws {

        let clientSpy = HTTPClientSpy()

        clientSpy.addStub(
            .success(
                (
                    Data(),
                    HTTPURLResponse(url: anyURL, statusCode: 204, httpVersion: nil, headerFields: nil)!
                )
            )
        )

        let sut = DefaultSolutionFilesRepository(
            apiClient: makeAPIClient(clientSpy)
        )

        try await sut.deleteSolutionFile(
            DeleteSolutionFileCommand(
                courseId: courseId,
                postId: postId,
                solutionId: solutionId,
                fileId: fileId
            )
        )

        let sentRequest = try #require(clientSpy.getRecordedRequests().first)

        #expect(sentRequest.httpMethod == "DELETE")

        #expect(
            sentRequest.url?.absoluteString ==
            "http://localhost:8080/api/v1/courses/\(courseId.uuidString)/posts/\(postId.uuidString)/solutions/\(solutionId.uuidString)/files/\(fileId.uuidString)"
        )
    }

    @Test("Download solution file routes to /download and returns binary data")
    func downloadSolutionFileRouting() async throws {

        let clientSpy = HTTPClientSpy()

        let binaryData = "raw_solution_bytes".data(using: .utf8)!

        clientSpy.addStub(
            .success(
                (
                    binaryData,
                    HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
                )
            )
        )

        let sut = DefaultSolutionFilesRepository(
            apiClient: makeAPIClient(clientSpy)
        )

        let result = try await sut.downloadSolutionFile(
            DownloadSolutionFileQuery(
                courseId: courseId,
                postId: postId,
                solutionId: solutionId,
                fileId: fileId
            )
        )

        #expect(result == binaryData)

        let sentRequest = try #require(clientSpy.getRecordedRequests().first)

        #expect(sentRequest.httpMethod == "GET")

        #expect(
            sentRequest.url?.absoluteString ==
            "http://localhost:8080/api/v1/courses/\(courseId.uuidString)/posts/\(postId.uuidString)/solutions/\(solutionId.uuidString)/files/\(fileId.uuidString)/download"
        )
    }
}
