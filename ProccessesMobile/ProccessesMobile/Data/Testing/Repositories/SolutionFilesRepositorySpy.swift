//
//  SolutionFilesRepositorySpy.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

actor SolutionFilesRepositorySpy: SolutionFilesRepository {

    private var uploadResult: Result<AttachedFile, Error> = .failure(APIError.invalidResponse)
    private var listResult: Result<[AttachedFile], Error> = .success([])
    private var deleteResult: Result<Void, Error> = .success(())
    private var downloadResult: Result<Data, Error> = .success(Data())

    func setUploadResult(_ result: Result<AttachedFile, Error>) { uploadResult = result }
    func setListResult(_ result: Result<[AttachedFile], Error>) { listResult = result }
    func setDeleteResult(_ result: Result<Void, Error>) { deleteResult = result }
    func setDownloadResult(_ result: Result<Data, Error>) { downloadResult = result }

    private var recordedUploadCommands: [UploadSolutionFileCommand] = []
    private var recordedListQueries: [ListSolutionFilesQuery] = []
    private var recordedDeleteCommands: [DeleteSolutionFileCommand] = []
    private var recordedDownloadQueries: [DownloadSolutionFileQuery] = []

    func getRecordedUploadCommands() -> [UploadSolutionFileCommand] { recordedUploadCommands }
    func getRecordedListQueries() -> [ListSolutionFilesQuery] { recordedListQueries }
    func getRecordedDeleteCommands() -> [DeleteSolutionFileCommand] { recordedDeleteCommands }
    func getRecordedDownloadQueries() -> [DownloadSolutionFileQuery] { recordedDownloadQueries }

    func listSolutionFiles(_ query: ListSolutionFilesQuery) async throws -> [AttachedFile] {
        recordedListQueries.append(query)
        return try listResult.get()
    }

    func deleteSolutionFile(_ command: DeleteSolutionFileCommand) async throws {
        recordedDeleteCommands.append(command)
        try deleteResult.get()
    }

    func downloadSolutionFile(_ query: DownloadSolutionFileQuery) async throws -> Data {
        recordedDownloadQueries.append(query)
        return try downloadResult.get()
    }

    func uploadSolutionFile(_ command: UploadSolutionFileCommand) async throws -> AttachedFile {
        recordedUploadCommands.append(command)
        return try uploadResult.get()
    }
}
