//
//  DefaultDeleteSolutionCommentUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//


import Foundation

struct DefaultDeleteSolutionCommentUseCase: DeleteSolutionCommentUseCase {
    let repository: SolutionCommentsRepository

    func execute(_ command: DeleteSolutionCommentCommand) async throws {
        try await repository.deleteComment(command)
    }
}