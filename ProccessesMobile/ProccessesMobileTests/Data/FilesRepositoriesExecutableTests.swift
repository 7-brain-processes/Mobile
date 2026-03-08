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
    
    let anyURL = URL(string: "http://localhost:8080/api/v1")!
    
    private func makeFileJSON() -> Data {
        return """
        {
            "id": "file_123",
            "originalName": "lecture_03.pdf",
            "contentType": "application/pdf",
            "sizeBytes": 204800,
            "uploadedAt": "2026-03-06T10:00:00Z"
        }
        """.data(using: .utf8)!
    }
    
    // MARK: - Post Materials Tests
    
    @Test("Upload material uses multipart/form-data and POST method")
    func uploadMaterialRouting() async throws {
        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(.success((makeFileJSON(), HTTPURLResponse(url: anyURL, statusCode: 201, httpVersion: nil, headerFields: nil)!)))
        let sut = MockPostMaterialsRepositoryImpl(client: clientSpy, baseURL: anyURL)
        
        let fileData = "fake_pdf_binary".data(using: .utf8)!
        let requestDto = UploadFileCommand(fileName: "lecture_03.pdf", mimeType: "application/pdf", data: fileData)
        
        let result = try await sut.uploadMaterial(courseId: "c1", postId: "p1", request: requestDto)
        
        #expect(result.id == "file_123")
        #expect(result.sizeBytes == 204800)
        
        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)
        
        #expect(sentRequest.httpMethod == "POST")
        #expect(sentRequest.url?.absoluteString == "http://localhost:8080/api/v1/courses/c1/posts/p1/materials")
        
        
        let contentType = try #require(sentRequest.value(forHTTPHeaderField: "Content-Type"))
        #expect(contentType.contains("multipart/form-data; boundary="))
        
        let sentBody = try #require(sentRequest.httpBody)
        let bodyString = String(data: sentBody, encoding: .utf8)!
        #expect(bodyString.contains("filename=\"lecture_03.pdf\""))
        #expect(bodyString.contains("fake_pdf_binary"))
    }
    
    @Test("Upload material maps 413 File Too Large correctly")
    func uploadMaterialFileTooLarge() async {
        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(.success((Data(), HTTPURLResponse(url: anyURL, statusCode: 413, httpVersion: nil, headerFields: nil)!)))
        let sut = MockPostMaterialsRepositoryImpl(client: clientSpy, baseURL: anyURL)
        
        let requestDto = UploadFileCommand(fileName: "huge.mp4", mimeType: "video/mp4", data: Data(repeating: 1, count: 10))
        
        await #expect(throws: APIError.serverError(code: 413)) {
            _ = try await sut.uploadMaterial(courseId: "c1", postId: "p1", request: requestDto)
        }
    }
    
    // MARK: - Solution Files Tests
    
    @Test("Upload solution file routes to correct subpath")
    func uploadSolutionFileRouting() async throws {
        let clientSpy = HTTPClientSpy()
        clientSpy.addStub(.success((makeFileJSON(), HTTPURLResponse(url: anyURL, statusCode: 201, httpVersion: nil, headerFields: nil)!)))
        let sut = MockSolutionFilesRepositoryImpl(client: clientSpy, baseURL: anyURL)
        
        let requestDto = UploadFileCommand(fileName: "homework.zip", mimeType: "application/zip", data: Data())
        _ = try await sut.uploadSolutionFile(courseId: "c1", postId: "p1", solutionId: "sol_1", request: requestDto)
        
        let requests = clientSpy.getRecordedRequests()
        let sentRequest = try #require(requests.first)
        
        #expect(sentRequest.httpMethod == "POST")
        #expect(sentRequest.url?.absoluteString == "http://localhost:8080/api/v1/courses/c1/posts/p1/solutions/sol_1/files")
    }
    private func makeFileListJSON() -> Data {
          return """
          [
              {
                  "id": "file_123",
                  "originalName": "lecture_03.pdf",
                  "contentType": "application/pdf",
                  "sizeBytes": 204800,
                  "uploadedAt": "2026-03-06T10:00:00Z"
              }
          ]
          """.data(using: .utf8)!
      }
      
      // MARK: - Additional Solution Files Network Tests
      
      @Test("List solution files routes to correct GET path")
      func listSolutionFilesRouting() async throws {
          let clientSpy = HTTPClientSpy()
          clientSpy.addStub(.success((makeFileListJSON(), HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!)))
          let sut = MockSolutionFilesRepositoryImpl(client: clientSpy, baseURL: anyURL)
          
          let result = try await sut.listSolutionFiles(courseId: "c1", postId: "p1", solutionId: "s1")
          
          #expect(result.count == 1)
          #expect(result.first?.id == "file_123")
          
          let requests = clientSpy.getRecordedRequests()
          #expect(requests.first?.httpMethod == "GET")
          #expect(requests.first?.url?.absoluteString == "http://localhost:8080/api/v1/courses/c1/posts/p1/solutions/s1/files")
      }
      
      @Test("Delete solution file routes to correct DELETE path")
      func deleteSolutionFileRouting() async throws {
          let clientSpy = HTTPClientSpy()
          clientSpy.addStub(.success((Data(), HTTPURLResponse(url: anyURL, statusCode: 204, httpVersion: nil, headerFields: nil)!)))
          let sut = MockSolutionFilesRepositoryImpl(client: clientSpy, baseURL: anyURL)
          
          try await sut.deleteSolutionFile(courseId: "c1", postId: "p1", solutionId: "s1", fileId: "file_99")
          
          let requests = clientSpy.getRecordedRequests()
          #expect(requests.first?.httpMethod == "DELETE")
          #expect(requests.first?.url?.absoluteString == "http://localhost:8080/api/v1/courses/c1/posts/p1/solutions/s1/files/file_99")
      }
      
      @Test("Download solution file routes to /download and returns binary data")
      func downloadSolutionFileRouting() async throws {
          let clientSpy = HTTPClientSpy()
          let binaryData = "raw_solution_bytes".data(using: .utf8)!
          clientSpy.addStub(.success((binaryData, HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!)))
          let sut = MockSolutionFilesRepositoryImpl(client: clientSpy, baseURL: anyURL)
          
          let result = try await sut.downloadSolutionFile(courseId: "c1", postId: "p1", solutionId: "s1", fileId: "file_99")
          
          #expect(result == binaryData)
          
          let requests = clientSpy.getRecordedRequests()
          #expect(requests.first?.httpMethod == "GET")
          #expect(requests.first?.url?.absoluteString == "http://localhost:8080/api/v1/courses/c1/posts/p1/solutions/s1/files/file_99/download")
      }
}
