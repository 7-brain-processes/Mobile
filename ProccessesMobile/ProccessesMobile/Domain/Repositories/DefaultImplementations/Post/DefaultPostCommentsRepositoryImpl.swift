//
//  DefaultPostCommentsRepositoryImpl.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct DefaultPostCommentsRepositoryImpl: PostCommentsRepository {

    private let client: HTTPClient
    private let baseURL: URL

    init(client: HTTPClient, baseURL: URL) {
        self.client = client
        self.baseURL = baseURL
    }

    func listComments(_ query: ListPostCommentsQuery) async throws -> Page<Comment> {

        let req = try PostCommentsEndpoint.list(
            courseId: query.courseId.uuidString,
            postId: query.postId.uuidString,
            page: query.page,
            size: query.size,
            baseURL: baseURL
        ).makeURLRequest()

        let (data, res) = try await client.send(req)

        try validate(res, success: 200)

        let dto = try JSONDecoder().decode(PageDTO<CommentDTO>.self, from: data)

        return try PageMapper.toDomain(
            dto,
            itemMapper: CommentMapper.toDomain
        )
    }

    func createComment(_ command: CreatePostCommentCommand) async throws -> Comment {

        let req = try PostCommentsEndpoint.create(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            request: CreatePostCommentMapper.toDTO(command),
            baseURL: baseURL
        ).makeURLRequest()

        let (data, res) = try await client.send(req)

        try validate(res, success: 201)

        let dto = try JSONDecoder().decode(CommentDTO.self, from: data)

        return try CommentMapper.toDomain(dto)
    }

    func updateComment(_ command: UpdatePostCommentCommand) async throws -> Comment {

        let req = try PostCommentsEndpoint.update(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            commentId: command.commentId.uuidString,
            request: UpdatePostCommentMapper.toDTO(command),
            baseURL: baseURL
        ).makeURLRequest()

        let (data, res) = try await client.send(req)

        try validate(res, success: 200)

        let dto = try JSONDecoder().decode(CommentDTO.self, from: data)

        return try CommentMapper.toDomain(dto)
    }

    func deleteComment(_ command: DeletePostCommentCommand) async throws {

        let req = try PostCommentsEndpoint.delete(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            commentId: command.commentId.uuidString,
            baseURL: baseURL
        ).makeURLRequest()

        let (_, res) = try await client.send(req)

        if res.statusCode == 200 || res.statusCode == 204 {
            return
        }

        try validate(res, success: 200)
    }
}
