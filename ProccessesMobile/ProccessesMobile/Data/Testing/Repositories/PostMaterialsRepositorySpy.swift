//
//  PostMaterialsRepositorySpy.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

actor PostMaterialsRepositorySpy: PostMaterialsRepository {

    private var uploadResult: Result<AttachedFile, Error> = .failure(APIError.invalidResponse)
    private var listResult: Result<[AttachedFile], Error> = .success([])
    private var deleteResult: Result<Void, Error> = .success(())
    private var downloadResult: Result<Data, Error> = .success(Data())

    private var recordedUploadCommands: [UploadPostMaterialCommand] = []
    private var recordedListQueries: [ListPostMaterialsQuery] = []
    private var recordedDeleteCommands: [DeletePostMaterialCommand] = []
    private var recordedDownloadQueries: [DownloadPostMaterialQuery] = []

    func setUploadResult(_ result: Result<AttachedFile, Error>) { uploadResult = result }
    func setListResult(_ result: Result<[AttachedFile], Error>) { listResult = result }
    func setDeleteResult(_ result: Result<Void, Error>) { deleteResult = result }
    func setDownloadResult(_ result: Result<Data, Error>) { downloadResult = result }

    func getRecordedUploadCommands() -> [UploadPostMaterialCommand] { recordedUploadCommands }
    func getRecordedListQueries() -> [ListPostMaterialsQuery] { recordedListQueries }
    func getRecordedDeleteCommands() -> [DeletePostMaterialCommand] { recordedDeleteCommands }
    func getRecordedDownloadQueries() -> [DownloadPostMaterialQuery] { recordedDownloadQueries }

    func uploadMaterial(_ command: UploadPostMaterialCommand) async throws -> AttachedFile {
        recordedUploadCommands.append(command)
        return try uploadResult.get()
    }

    func listMaterials(_ query: ListPostMaterialsQuery) async throws -> [AttachedFile] {
        recordedListQueries.append(query)
        return try listResult.get()
    }

    func deleteMaterial(_ command: DeletePostMaterialCommand) async throws {
        recordedDeleteCommands.append(command)
        try deleteResult.get()
    }

    func downloadMaterial(_ query: DownloadPostMaterialQuery) async throws -> Data {
        recordedDownloadQueries.append(query)
        return try downloadResult.get()
    }
}
