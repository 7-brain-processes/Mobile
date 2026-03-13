//
//  DefaultSolutionFilesRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct DefaultSolutionFilesRepository: SolutionFilesRepository, Sendable {

    private let apiClient: APIClient
    private let decoder: JSONDecoder

    init(
        apiClient: APIClient,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.apiClient = apiClient
        self.decoder = decoder
    }

    func listSolutionFiles(_ query: ListSolutionFilesQuery) async throws -> [AttachedFile] {
        let endpoint = SolutionFilesEndpoint.list(
            courseId: query.courseId.uuidString,
            postId: query.postId.uuidString,
            solutionId: query.solutionId.uuidString
        )

        let (data, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [200])

        let dto = try decoder.decode([AttachedFileDTO].self, from: data)

        return try dto.map(AttachedFileMapper.toDomain)
    }

    func uploadSolutionFile(_ command: UploadSolutionFileCommand) async throws -> AttachedFile {
        let endpoint = SolutionFilesEndpoint.upload(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            solutionId: command.solutionId.uuidString,
            request: UploadSolutionFileMapper.toDTO(command)
        )

        let (data, response) = try await apiClient.send(endpoint)

        if response.statusCode == 413 {
            throw APIError.serverError(code: 413)
        }

        try ResponseValidator.validate(response, successCodes: [201])

        let dto = try decoder.decode(AttachedFileDTO.self, from: data)

        return try AttachedFileMapper.toDomain(dto)
    }

    func deleteSolutionFile(_ command: DeleteSolutionFileCommand) async throws {
        let endpoint = SolutionFilesEndpoint.delete(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            solutionId: command.solutionId.uuidString,
            fileId: command.fileId.uuidString
        )

        let (_, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [200, 204])
    }

    func downloadSolutionFile(_ query: DownloadSolutionFileQuery) async throws -> Data {
        let endpoint = SolutionFilesEndpoint.download(
            courseId: query.courseId.uuidString,
            postId: query.postId.uuidString,
            solutionId: query.solutionId.uuidString,
            fileId: query.fileId.uuidString
        )

        let (data, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [200])

        return data
    }
}
