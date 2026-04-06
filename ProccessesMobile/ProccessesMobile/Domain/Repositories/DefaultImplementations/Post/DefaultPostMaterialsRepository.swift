//
//  DefaultPostMaterialsRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct DefaultPostMaterialsRepository: PostMaterialsRepository, Sendable {

    private let apiClient: APIClient
    private let decoder: JSONDecoder

    init(
        apiClient: APIClient,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.apiClient = apiClient
        self.decoder = decoder
    }

    func listMaterials(_ query: ListPostMaterialsQuery) async throws -> [AttachedFile] {

        let endpoint = PostMaterialsEndpoint.list(
            courseId: query.courseId.uuidString,
            postId: query.postId.uuidString
        )

        let (data, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [200])

        let dto = try decoder.decode([AttachedFileDTO].self, from: data)

        return try dto.map(AttachedFileMapper.toDomain)
    }

    func uploadMaterial(_ command: UploadPostMaterialCommand) async throws -> AttachedFile {

        let endpoint = PostMaterialsEndpoint.upload(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            request: UploadPostMaterialMapper.toDTO(command)
        )

        let (data, response) = try await apiClient.send(endpoint)

        if response.statusCode == 413 {
            throw APIError.serverError(code: 413)
        }

        try ResponseValidator.validate(response, successCodes: [201])

        let dto = try decoder.decode(AttachedFileDTO.self, from: data)

        return try AttachedFileMapper.toDomain(dto)
    }

    func deleteMaterial(_ command: DeletePostMaterialCommand) async throws {

        let endpoint = PostMaterialsEndpoint.delete(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            fileId: command.fileId.uuidString
        )

        let (_, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [200, 204])
    }

    func downloadMaterial(_ query: DownloadPostMaterialQuery) async throws -> Data {

        let endpoint = PostMaterialsEndpoint.download(
            courseId: query.courseId.uuidString,
            postId: query.postId.uuidString,
            fileId: query.fileId.uuidString
        )

        let (data, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [200])

        return data
    }
}
