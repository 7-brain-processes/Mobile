//
//  FilesUseCasesExecutableTests.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


import Testing
import Foundation
@testable import ProccessesMobile

@Suite("File Attachments Domain: Executable Specification")
struct FilesUseCasesExecutableTests {
    
    // MARK: - Factories
    
    func makePostMaterialSUT(repo: PostMaterialsRepository) -> UploadPostMaterialUseCase {
        return MockUploadPostMaterialUseCase(repository: repo)
    }
    
    func makeSolutionFileSUT(repo: SolutionFilesRepository) -> UploadSolutionFileUseCase {
        return MockUploadSolutionFileUseCase(repository: repo)
    }
    
    let dummyFile = AttachedFile(id: "f_1", originalName: "test.pdf", contentType: "application/pdf", sizeBytes: 1024, uploadedAt: "2026-03-06")
    let validData = "dummy file content".data(using: .utf8)!
    
    // MARK: - Post Materials Use Case Tests
    
    @Test("Upload post material delegates successfully")
    func uploadPostMaterialSuccess() async throws {
        let repoSpy = PostMaterialsRepositorySpy()
        await repoSpy.setUploadResult(.success(dummyFile))
        let sut = makePostMaterialSUT(repo: repoSpy)
        
        let request = UploadFileCommand(fileName: "test.pdf", mimeType: "application/pdf", data: validData)
        let result = try await sut.execute(courseId: "c1", postId: "p1", request: request)
        
        #expect(result == dummyFile)
        let args = await repoSpy.getRecordedUploadArgs()
        #expect(args.first?.request.fileName == "test.pdf")
    }
    
    @Test("Upload post material validates missing IDs or empty names")
    func uploadPostMaterialIDValidations() async {
        let repoSpy = PostMaterialsRepositorySpy()
        let sut = makePostMaterialSUT(repo: repoSpy)
        
        let request = UploadFileCommand(fileName: "  ", mimeType: "pdf", data: validData)
        
        await #expect(throws: FileValidationError.emptyId("courseId")) {
            _ = try await sut.execute(courseId: "   ", postId: "p1", request: request)
        }
        
        await #expect(throws: FileValidationError.emptyId("postId")) {
            _ = try await sut.execute(courseId: "c1", postId: "", request: request)
        }
        
        await #expect(throws: FileValidationError.invalidFileName) {
            _ = try await sut.execute(courseId: "c1", postId: "p1", request: request)
        }
    }
    
    @Test("Upload post material rejects empty file data")
    func uploadPostMaterialEmptyData() async {
        let repoSpy = PostMaterialsRepositorySpy()
        let sut = makePostMaterialSUT(repo: repoSpy)
        
        let request = UploadFileCommand(fileName: "valid.pdf", mimeType: "pdf", data: Data())
        
        await #expect(throws: FileValidationError.emptyFileData) {
            _ = try await sut.execute(courseId: "c1", postId: "p1", request: request)
        }
    }
    
    // MARK: - Solution Files Use Case Tests
    
    @Test("Upload solution file delegates successfully")
    func uploadSolutionFileSuccess() async throws {
        let repoSpy = SolutionFilesRepositorySpy()
        await repoSpy.setUploadResult(.success(dummyFile))
        let sut = makeSolutionFileSUT(repo: repoSpy)
        
        let request = UploadFileCommand(fileName: "homework.zip", mimeType: "application/zip", data: validData)
        let result = try await sut.execute(courseId: "c1", postId: "p1", solutionId: "s1", request: request)
        
        #expect(result == dummyFile)
        let args = await repoSpy.getRecordedUploadArgs()
        #expect(args.first?.solutionId == "s1")
        #expect(args.first?.request.fileName == "homework.zip")
    }
    
    @Test("Upload solution file validates IDs and data")
    func uploadSolutionFileValidations() async {
        let repoSpy = SolutionFilesRepositorySpy()
        let sut = makeSolutionFileSUT(repo: repoSpy)
        
        await #expect(throws: FileValidationError.emptyId("solutionId")) {
            let request = UploadFileCommand(fileName: "valid.pdf", mimeType: "pdf", data: validData)
            _ = try await sut.execute(courseId: "c1", postId: "p1", solutionId: "   ", request: request)
        }
        
        await #expect(throws: FileValidationError.emptyFileData) {
            let request = UploadFileCommand(fileName: "valid.pdf", mimeType: "pdf", data: Data())
            _ = try await sut.execute(courseId: "c1", postId: "p1", solutionId: "s1", request: request)
        }
    }
    @Test("List post materials delegates successfully")
      func listPostMaterialsSuccess() async throws {
          let repoSpy = PostMaterialsRepositorySpy()
          await repoSpy.setListResult(.success([dummyFile]))
          let sut = MockListPostMaterialsUseCase(repo: repoSpy)
          
          let result = try await sut.execute(courseId: "c1", postId: "p1")
          #expect(result == [dummyFile])
          
          let args = await repoSpy.getRecordedListArgs()
          #expect(args.first?.courseId == "c1")
      }
      
      @Test("Delete and Download post material validates fileId")
      func deleteAndDownloadPostMaterialValidations() async {
          let repoSpy = PostMaterialsRepositorySpy()
          let deleteSUT = MockDeletePostMaterialUseCase(repo: repoSpy)
          let downloadSUT = MockDownloadPostMaterialUseCase(repo: repoSpy)
          
          await #expect(throws: FileValidationError.emptyId("fileId")) {
              try await deleteSUT.execute(courseId: "c1", postId: "p1", fileId: "   ")
          }
          
          await #expect(throws: FileValidationError.emptyId("fileId")) {
              _ = try await downloadSUT.execute(courseId: "c1", postId: "p1", fileId: "")
          }
      }
      
      // MARK: - Additional Solution Files Use Case Tests
      
      @Test("List solution files delegates successfully")
      func listSolutionFilesSuccess() async throws {
          let repoSpy = SolutionFilesRepositorySpy()
          await repoSpy.setListResult(.success([dummyFile]))
          let sut = MockListSolutionFilesUseCase(repo: repoSpy)
          
          let result = try await sut.execute(courseId: "c1", postId: "p1", solutionId: "s1")
          #expect(result == [dummyFile])
          
          let args = await repoSpy.getRecordedListArgs()
          #expect(args.first?.solutionId == "s1")
      }
      
      @Test("Delete and Download solution file validates fileId")
      func deleteAndDownloadSolutionFileValidations() async {
          let repoSpy = SolutionFilesRepositorySpy()
          let deleteSUT = MockDeleteSolutionFileUseCase(repo: repoSpy)
          let downloadSUT = MockDownloadSolutionFileUseCase(repo: repoSpy)
          
          await #expect(throws: FileValidationError.emptyId("fileId")) {
              try await deleteSUT.execute(courseId: "c1", postId: "p1", solutionId: "s1", fileId: "   ")
          }
          
          await #expect(throws: FileValidationError.emptyId("fileId")) {
              _ = try await downloadSUT.execute(courseId: "c1", postId: "p1", solutionId: "s1", fileId: "")
          }
      }
}
