//
//  DefaultSolutionCommentsRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct DefaultSolutionCommentsRepository: SolutionCommentsRepository, Sendable {

    private let apiClient: APIClient
    private let decoder: JSONDecoder

    init(
        apiClient: APIClient,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.apiClient = apiClient
        self.decoder = decoder
    }

    func listComments(_ query: ListSolutionCommentsQuery) async throws -> Page<Comment> {

        let endpoint = SolutionCommentsEndpoint.list(
            courseId: query.courseId.uuidString,
            postId: query.postId.uuidString,
            solutionId: query.solutionId.uuidString,
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

    func createComment(_ command: CreateSolutionCommentCommand) async throws -> Comment {

        let endpoint = SolutionCommentsEndpoint.create(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            solutionId: command.solutionId.uuidString,
            request: CreateSolutionCommentMapper.toDTO(command)
        )

        let (data, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [201])

        let dto = try decoder.decode(CommentDTO.self, from: data)

        return try CommentMapper.toDomain(dto)
    }

    func updateComment(_ command: UpdateSolutionCommentCommand) async throws -> Comment {

        let endpoint = SolutionCommentsEndpoint.update(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            solutionId: command.solutionId.uuidString,
            commentId: command.commentId.uuidString,
            request: UpdateSolutionCommentMapper.toDTO(command)
        )

        let (data, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [200])

        let dto = try decoder.decode(CommentDTO.self, from: data)

        return try CommentMapper.toDomain(dto)
    }

    func deleteComment(_ command: DeleteSolutionCommentCommand) async throws {

        let endpoint = SolutionCommentsEndpoint.delete(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            solutionId: command.solutionId.uuidString,
            commentId: command.commentId.uuidString
        )

        let (_, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [200, 204])
    }
}
