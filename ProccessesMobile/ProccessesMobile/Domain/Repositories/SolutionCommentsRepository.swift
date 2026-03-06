//
//  SolutionCommentsRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public protocol SolutionCommentsRepository: Sendable {
    func listComments(courseId: String, postId: String, solutionId: String, page: Int, size: Int) async throws -> PageComment
    func createComment(courseId: String, postId: String, solutionId: String, request: CreateCommentRequest) async throws -> Comment
    func updateComment(courseId: String, postId: String, solutionId: String, commentId: String, request: CreateCommentRequest) async throws -> Comment
    func deleteComment(courseId: String, postId: String, solutionId: String, commentId: String) async throws
}
