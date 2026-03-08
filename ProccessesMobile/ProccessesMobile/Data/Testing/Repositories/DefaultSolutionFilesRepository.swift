//
//  DefaultSolutionFilesRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct DefaultSolutionFilesRepository: SolutionFilesRepository {
    private let client: HTTPClient
    private let baseURL: URL

    init(client: HTTPClient, baseURL: URL) {
        self.client = client
        self.baseURL = baseURL
    }

    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }

    func listSolutionFiles(_ query: ListSolutionFilesQuery) async throws -> [AttachedFile] {
        let request = try SolutionFilesEndpoint.list(
            courseId: query.courseId.uuidString,
            postId: query.postId.uuidString,
            solutionId: query.solutionId.uuidString,
            baseURL: baseURL
        ).makeURLRequest()

        let (data, response) = try await client.send(request)

        try validate(response, success: 200)

        let dto = try decoder.decode([AttachedFileDTO].self, from: data)
        return try dto.map { try $0.toDomain() }
    }

    func uploadSolutionFile(_ command: UploadSolutionFileCommand) async throws -> AttachedFile {
        let request = try SolutionFilesEndpoint.upload(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            solutionId: command.solutionId.uuidString,
            request: command.toDTO(),
            baseURL: baseURL
        ).makeURLRequest()

        let (data, response) = try await client.send(request)

        if response.statusCode == 413 {
            throw APIError.serverError(code: 413)
        }

        try validate(response, success: 201)

        let dto = try decoder.decode(AttachedFileDTO.self, from: data)
        return try dto.toDomain()
    }

    func deleteSolutionFile(_ command: DeleteSolutionFileCommand) async throws {
        let request = try SolutionFilesEndpoint.delete(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            solutionId: command.solutionId.uuidString,
            fileId: command.fileId.uuidString,
            baseURL: baseURL
        ).makeURLRequest()

        let (_, response) = try await client.send(request)

        if response.statusCode == 200 || response.statusCode == 204 {
            return
        }

        try validate(response, success: 200)
    }

    func downloadSolutionFile(_ query: DownloadSolutionFileQuery) async throws -> Data {
        let request = try SolutionFilesEndpoint.download(
            courseId: query.courseId.uuidString,
            postId: query.postId.uuidString,
            solutionId: query.solutionId.uuidString,
            fileId: query.fileId.uuidString,
            baseURL: baseURL
        ).makeURLRequest()

        let (data, response) = try await client.send(request)

        try validate(response, success: 200)

        return data
    }
}
