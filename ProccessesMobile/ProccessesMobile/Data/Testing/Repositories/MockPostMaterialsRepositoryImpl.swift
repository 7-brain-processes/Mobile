//
//  MockPostMaterialsRepositoryImpl.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct MockPostMaterialsRepositoryImpl: PostMaterialsRepository {

    private let client: HTTPClient
    private let baseURL: URL

    init(client: HTTPClient, baseURL: URL) {
        self.client = client
        self.baseURL = baseURL
    }

    private var decoder: JSONDecoder {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }

    func listMaterials(_ query: ListPostMaterialsQuery) async throws -> [AttachedFile] {

        let req = try PostMaterialsEndpoint.list(
            courseId: query.courseId.uuidString,
            postId: query.postId.uuidString,
            baseURL: baseURL
        ).makeURLRequest()

        let (data, res) = try await client.send(req)

        try validate(res, success: 200)

        let dto = try decoder.decode([AttachedFileDTO].self, from: data)

        return try dto.map { try $0.toDomain() }
    }

    func uploadMaterial(_ command: UploadPostMaterialCommand) async throws -> AttachedFile {

        let req = try PostMaterialsEndpoint.upload(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            request: command.toDTO(),
            baseURL: baseURL
        ).makeURLRequest()

        let (data, res) = try await client.send(req)

        if res.statusCode == 413 {
            throw APIError.serverError(code: 413)
        }

        try validate(res, success: 201)

        let dto = try decoder.decode(AttachedFileDTO.self, from: data)

        return try dto.toDomain()
    }

    func deleteMaterial(_ command: DeletePostMaterialCommand) async throws {

        let req = try PostMaterialsEndpoint.delete(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            fileId: command.fileId.uuidString,
            baseURL: baseURL
        ).makeURLRequest()

        let (_, res) = try await client.send(req)

        if res.statusCode == 200 || res.statusCode == 204 {
            return
        }

        try validate(res, success: 200)
    }

    func downloadMaterial(_ query: DownloadPostMaterialQuery) async throws -> Data {

        let req = try PostMaterialsEndpoint.download(
            courseId: query.courseId.uuidString,
            postId: query.postId.uuidString,
            fileId: query.fileId.uuidString,
            baseURL: baseURL
        ).makeURLRequest()

        let (data, res) = try await client.send(req)

        try validate(res, success: 200)

        return data
    }
}
