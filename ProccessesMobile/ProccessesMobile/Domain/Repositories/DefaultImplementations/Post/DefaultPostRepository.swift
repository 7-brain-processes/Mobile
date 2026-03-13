//
//  DefaultPostRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct DefaultPostRepository: PostRepository, Sendable {

    private let apiClient: APIClient
    private let decoder: JSONDecoder

    init(
        apiClient: APIClient,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.apiClient = apiClient
        self.decoder = decoder
    }

    private func decodeResponse<T: Decodable>(
        data: Data,
        response: HTTPURLResponse,
        successCodes: Set<Int>
    ) throws -> T {
        try ResponseValidator.validate(response, successCodes: successCodes)
        return try decoder.decode(T.self, from: data)
    }

    func listPosts(_ query: ListPostsQuery) async throws -> Page<Post> {
        let endpoint = PostEndpoint.list(
            courseId: query.courseId.uuidString,
            page: query.page,
            size: query.size,
            type: query.type.map(PostTypeMapper.toDTO)
        )

        let (data, response) = try await apiClient.send(endpoint)

        let dto: PageDTO<PostDTO> = try decodeResponse(
            data: data,
            response: response,
            successCodes: [200]
        )

        return try PageMapper.toDomain(
            dto,
            itemMapper: PostMapper.toDomain
        )
    }

    func createPost(_ command: CreatePostCommand) async throws -> Post {
        let endpoint = PostEndpoint.create(
            courseId: command.courseId.uuidString,
            request: CreatePostMapper.toDTO(command)
        )

        let (data, response) = try await apiClient.send(endpoint)

        let dto: PostDTO = try decodeResponse(
            data: data,
            response: response,
            successCodes: [201]
        )

        return try PostMapper.toDomain(dto)
    }

    func getPost(courseId: UUID, postId: UUID) async throws -> Post {
        let endpoint = PostEndpoint.get(
            courseId: courseId.uuidString,
            postId: postId.uuidString
        )

        let (data, response) = try await apiClient.send(endpoint)

        let dto: PostDTO = try decodeResponse(
            data: data,
            response: response,
            successCodes: [200]
        )

        return try PostMapper.toDomain(dto)
    }

    func updatePost(_ command: UpdatePostCommand) async throws -> Post {
        let endpoint = PostEndpoint.update(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            request: UpdatePostMapper.toDTO(command)
        )

        let (data, response) = try await apiClient.send(endpoint)

        let dto: PostDTO = try decodeResponse(
            data: data,
            response: response,
            successCodes: [200]
        )

        return try PostMapper.toDomain(dto)
    }

    func deletePost(courseId: UUID, postId: UUID) async throws {
        let endpoint = PostEndpoint.delete(
            courseId: courseId.uuidString,
            postId: postId.uuidString
        )

        let (_, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [200, 204])
    }
}
