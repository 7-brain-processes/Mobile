//
//  DefaultPostCommentsRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct DefaultPostCommentsRepository: PostCommentsRepository, Sendable {

    private let apiClient: APIClient
    private let decoder: JSONDecoder

    init(
        apiClient: APIClient,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.apiClient = apiClient
        self.decoder = decoder
    }

    func listComments(_ query: ListPostCommentsQuery) async throws -> Page<Comment> {

        let endpoint = PostCommentsEndpoint.list(
            courseId: query.courseId.uuidString,
            postId: query.postId.uuidString,
            page: query.page,
            size: query.size
        )

        let (data, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [200])

        let dto = try decoder.decode(PageDTO<CommentDTO>.self, from: data)

        return try PageMapper.toDomain(
            dto,
            itemMapper: CommentMapper.toDomain
        )
    }

    func createComment(_ command: CreatePostCommentCommand) async throws -> Comment {

        let endpoint = PostCommentsEndpoint.create(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            request: CreatePostCommentMapper.toDTO(command)
        )

        let (data, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [201])

        let dto = try decoder.decode(CommentDTO.self, from: data)

        return try CommentMapper.toDomain(dto)
    }

    func updateComment(_ command: UpdatePostCommentCommand) async throws -> Comment {

        let endpoint = PostCommentsEndpoint.update(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            commentId: command.commentId.uuidString,
            request: UpdatePostCommentMapper.toDTO(command)
        )

        let (data, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [200])

        let dto = try decoder.decode(CommentDTO.self, from: data)

        return try CommentMapper.toDomain(dto)
    }

    func deleteComment(_ command: DeletePostCommentCommand) async throws {

        let endpoint = PostCommentsEndpoint.delete(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            commentId: command.commentId.uuidString
        )

        let (_, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [200, 204])
    }
}
