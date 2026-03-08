//
//  MockPostRepositoryImpl.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct MockPostRepositoryImpl: PostRepository {
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

    private func handleResponse<T: Decodable>(
        data: Data,
        response: HTTPURLResponse,
        successCodes: [Int]
    ) throws -> T {
        if response.statusCode == 401 { throw APIError.unauthorized }
        if response.statusCode == 403 { throw APIError.serverError(code: 403) }
        if response.statusCode == 404 { throw APIError.serverError(code: 404) }
        guard successCodes.contains(response.statusCode) else {
            throw APIError.serverError(code: response.statusCode)
        }
        return try decoder.decode(T.self, from: data)
    }

    func listPosts(_ query: ListPostsQuery) async throws -> Page<Post> {
        let req = try PostEndpoint.list(
            courseId: query.courseId.uuidString,
            page: query.page,
            size: query.size,
            type: query.type?.toDTO(),
            baseURL: baseURL
        ).makeURLRequest()

        let (data, res) = try await client.send(req)

        let dto: PagePostDTO = try handleResponse(
            data: data,
            response: res,
            successCodes: [200]
        )

        return try dto.toDomain { try $0.toDomain() }
    }

    func createPost(_ command: CreatePostCommand) async throws -> Post {
        let req = try PostEndpoint.create(
            courseId: command.courseId.uuidString,
            request: command.toDTO(),
            baseURL: baseURL
        ).makeURLRequest()

        let (data, res) = try await client.send(req)

        let dto: PostDTO = try handleResponse(
            data: data,
            response: res,
            successCodes: [201]
        )

        return try dto.toDomain()
    }

    func getPost(courseId: UUID, postId: UUID) async throws -> Post {
        let req = try PostEndpoint.get(
            courseId: courseId.uuidString,
            postId: postId.uuidString,
            baseURL: baseURL
        ).makeURLRequest()

        let (data, res) = try await client.send(req)

        let dto: PostDTO = try handleResponse(
            data: data,
            response: res,
            successCodes: [200]
        )

        return try dto.toDomain()
    }

    func updatePost(_ command: UpdatePostCommand) async throws -> Post {
        let req = try PostEndpoint.update(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            request: command.toDTO(),
            baseURL: baseURL
        ).makeURLRequest()

        let (data, res) = try await client.send(req)

        let dto: PostDTO = try handleResponse(
            data: data,
            response: res,
            successCodes: [200]
        )

        return try dto.toDomain()
    }

    func deletePost(courseId: UUID, postId: UUID) async throws {
        let req = try PostEndpoint.delete(
            courseId: courseId.uuidString,
            postId: postId.uuidString,
            baseURL: baseURL
        ).makeURLRequest()

        let (_, res) = try await client.send(req)

        if res.statusCode == 401 { throw APIError.unauthorized }
        if res.statusCode == 403 { throw APIError.serverError(code: 403) }
        if res.statusCode == 404 { throw APIError.serverError(code: 404) }
        guard res.statusCode == 204 || res.statusCode == 200 else {
            throw APIError.serverError(code: res.statusCode)
        }
    }
}
