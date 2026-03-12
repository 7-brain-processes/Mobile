//
//  DefaultSolutionCommentsRepositoryImpl.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct DefaultSolutionCommentsRepositoryImpl: SolutionCommentsRepository {
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

    func listComments(_ query: ListSolutionCommentsQuery) async throws -> Page<Comment> {
        let req = try SolutionCommentsEndpoint.list(
            courseId: query.courseId.uuidString,
            postId: query.postId.uuidString,
            solutionId: query.solutionId.uuidString,
            page: query.page,
            size: query.size,
            baseURL: baseURL
        ).makeURLRequest()

        let (data, res) = try await client.send(req)
        try validate(res, success: 200)

        let dto = try decoder.decode(PageCommentDTO.self, from: data)
        return try dto.toDomain { try $0.toDomain() }
    }

    func createComment(_ command: CreateSolutionCommentCommand) async throws -> Comment {
        let req = try SolutionCommentsEndpoint.create(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            solutionId: command.solutionId.uuidString,
            request: command.toDTO(),
            baseURL: baseURL
        ).makeURLRequest()

        let (data, res) = try await client.send(req)
        try validate(res, success: 201)

        let dto = try decoder.decode(CommentDTO.self, from: data)
        return try dto.toDomain()
    }

    func updateComment(_ command: UpdateSolutionCommentCommand) async throws -> Comment {
        let req = try SolutionCommentsEndpoint.update(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            solutionId: command.solutionId.uuidString,
            commentId: command.commentId.uuidString,
            request: command.toDTO(),
            baseURL: baseURL
        ).makeURLRequest()

        let (data, res) = try await client.send(req)
        try validate(res, success: 200)

        let dto = try decoder.decode(CommentDTO.self, from: data)
        return try dto.toDomain()
    }

    func deleteComment(_ command: DeleteSolutionCommentCommand) async throws {
        let req = try SolutionCommentsEndpoint.delete(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            solutionId: command.solutionId.uuidString,
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
