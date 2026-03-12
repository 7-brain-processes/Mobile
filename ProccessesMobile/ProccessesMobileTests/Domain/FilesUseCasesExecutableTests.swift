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

    private func makePostMaterialSUT(repo: PostMaterialsRepository) -> UploadPostMaterialUseCase {
        DefaultUploadPostMaterialUseCase(repository: repo)
    }

    private func makeSolutionFileSUT(repo: SolutionFilesRepository) -> UploadSolutionFileUseCase {
        DefaultUploadSolutionFileUseCase(repository: repo)
    }

    private let validData = "dummy file content".data(using: .utf8)!

    private let dummyFile = AttachedFile(
        id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440111")!,
        originalName: "test.pdf",
        contentType: "application/pdf",
        sizeBytes: 1024,
        uploadedAt: Date()
    )

    // MARK: - Post Materials Use Case Tests

    @Test("Upload post material delegates successfully")
    func uploadPostMaterialSuccess() async throws {

        let repoSpy = PostMaterialsRepositorySpy()
        await repoSpy.setUploadResult(.success(dummyFile))

        let sut = makePostMaterialSUT(repo: repoSpy)

        let command = UploadPostMaterialCommand(
            courseId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!,
            postId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440002")!,
            fileName: "test.pdf",
            mimeType: "application/pdf",
            data: validData
        )

        let result = try await sut.execute(command)

        #expect(result == dummyFile)

        let commands = await repoSpy.getRecordedUploadCommands()
        #expect(commands.first?.fileName == "test.pdf")
    }

    @Test("Upload post material rejects empty file name")
    func uploadPostMaterialInvalidFileName() async {

        let repoSpy = PostMaterialsRepositorySpy()
        let sut = makePostMaterialSUT(repo: repoSpy)

        await #expect(throws: FileValidationError.invalidFileName) {

            try await sut.execute(
                UploadPostMaterialCommand(
                    courseId: UUID(),
                    postId: UUID(),
                    fileName: "   ",
                    mimeType: "application/pdf",
                    data: validData
                )
            )
        }
    }

    @Test("Upload post material rejects empty file data")
    func uploadPostMaterialEmptyData() async {

        let repoSpy = PostMaterialsRepositorySpy()
        let sut = makePostMaterialSUT(repo: repoSpy)

        await #expect(throws: FileValidationError.emptyFileData) {

            try await sut.execute(
                UploadPostMaterialCommand(
                    courseId: UUID(),
                    postId: UUID(),
                    fileName: "valid.pdf",
                    mimeType: "application/pdf",
                    data: Data()
                )
            )
        }
    }

    // MARK: - Solution Files Use Case Tests

    @Test("Upload solution file delegates successfully")
    func uploadSolutionFileSuccess() async throws {

        let repoSpy = SolutionFilesRepositorySpy()
        await repoSpy.setUploadResult(.success(dummyFile))

        let sut = makeSolutionFileSUT(repo: repoSpy)

        let command = UploadSolutionFileCommand(
            courseId: UUID(),
            postId: UUID(),
            solutionId: UUID(),
            fileName: "homework.zip",
            mimeType: "application/zip",
            data: validData
        )

        let result = try await sut.execute(command)

        #expect(result == dummyFile)

        let commands = await repoSpy.getRecordedUploadCommands()
        #expect(commands.first?.fileName == "homework.zip")
    }

    @Test("Upload solution file validates empty data")
    func uploadSolutionFileValidations() async {

        let repoSpy = SolutionFilesRepositorySpy()
        let sut = makeSolutionFileSUT(repo: repoSpy)

        await #expect(throws: FileValidationError.emptyFileData) {

            try await sut.execute(
                UploadSolutionFileCommand(
                    courseId: UUID(),
                    postId: UUID(),
                    solutionId: UUID(),
                    fileName: "valid.pdf",
                    mimeType: "application/pdf",
                    data: Data()
                )
            )
        }
    }
}
