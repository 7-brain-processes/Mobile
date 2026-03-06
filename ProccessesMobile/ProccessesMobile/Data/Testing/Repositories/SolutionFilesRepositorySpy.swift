//
//  SolutionFilesRepositorySpy.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

actor SolutionFilesRepositorySpy: SolutionFilesRepository {
    // Results
    private var uploadResult: Result<AttachedFile, Error> = .failure(APIError.invalidResponse)
    private var listResult: Result<[AttachedFile], Error> = .success([])
    private var deleteResult: Result<Void, Error> = .success(())
    private var downloadResult: Result<Data, Error> = .success(Data())
    
    // Setters
    func setUploadResult(_ result: Result<AttachedFile, Error>) { uploadResult = result }
    func setListResult(_ result: Result<[AttachedFile], Error>) { listResult = result }
    func setDeleteResult(_ result: Result<Void, Error>) { deleteResult = result }
    func setDownloadResult(_ result: Result<Data, Error>) { downloadResult = result }
    
    // Trackers
    struct UploadArgs: Equatable { let courseId: String; let postId: String; let solutionId: String; let request: UploadFileRequest }
    struct ListArgs: Equatable { let courseId: String; let postId: String; let solutionId: String }
    struct FileArgs: Equatable { let courseId: String; let postId: String; let solutionId: String; let fileId: String }
    
    private var recordedUploadArgs: [UploadArgs] = []
    private var recordedListArgs: [ListArgs] = []
    private var recordedDeleteArgs: [FileArgs] = []
    private var recordedDownloadArgs: [FileArgs] = []
    
    // Getters
    func getRecordedUploadArgs() -> [UploadArgs] { return recordedUploadArgs }
    func getRecordedListArgs() -> [ListArgs] { return recordedListArgs }
    func getRecordedDeleteArgs() -> [FileArgs] { return recordedDeleteArgs }
    func getRecordedDownloadArgs() -> [FileArgs] { return recordedDownloadArgs }
    
    // Protocol Implementation
    func listSolutionFiles(courseId: String, postId: String, solutionId: String) async throws -> [AttachedFile] {
        recordedListArgs.append(ListArgs(courseId: courseId, postId: postId, solutionId: solutionId))
        return try listResult.get()
    }
    
    func deleteSolutionFile(courseId: String, postId: String, solutionId: String, fileId: String) async throws {
        recordedDeleteArgs.append(FileArgs(courseId: courseId, postId: postId, solutionId: solutionId, fileId: fileId))
        return try deleteResult.get()
    }
    
    func downloadSolutionFile(courseId: String, postId: String, solutionId: String, fileId: String) async throws -> Data {
        recordedDownloadArgs.append(FileArgs(courseId: courseId, postId: postId, solutionId: solutionId, fileId: fileId))
        return try downloadResult.get()
    }
    
    func uploadSolutionFile(courseId: String, postId: String, solutionId: String, request: UploadFileRequest) async throws -> AttachedFile {
        recordedUploadArgs.append(UploadArgs(courseId: courseId, postId: postId, solutionId: solutionId, request: request))
        return try uploadResult.get()
    }
}
