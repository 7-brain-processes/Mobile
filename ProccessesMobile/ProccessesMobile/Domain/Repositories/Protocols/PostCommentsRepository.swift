//
//  PostCommentsRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

protocol PostCommentsRepository: Sendable {
    func listComments(_ query: ListPostCommentsQuery) async throws -> Page<Comment>
    func createComment(_ command: CreatePostCommentCommand) async throws -> Comment
    func updateComment(_ command: UpdatePostCommentCommand) async throws -> Comment
    func deleteComment(_ command: DeletePostCommentCommand) async throws
}

struct ListPostCommentsQuery: Sendable {
    let courseId: UUID
    let postId: UUID
    let page: Int
    let size: Int
}

struct DeletePostCommentCommand: Sendable {
    let courseId: UUID
    let postId: UUID
    let commentId: UUID
}
