//
//  SolutionCommentsRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

protocol SolutionCommentsRepository: Sendable {
    func createComment(_ command: CreateSolutionCommentCommand) async throws -> Comment
    func updateComment(_ command: UpdateSolutionCommentCommand) async throws -> Comment
    func deleteComment(_ command: DeleteSolutionCommentCommand) async throws
    func listComments(_ query: ListSolutionCommentsQuery) async throws -> Page<Comment>
}
