//
//  CreateSolutionCommentUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

protocol CreateSolutionCommentUseCase: Sendable {
    func execute(_ command: CreateSolutionCommentCommand) async throws -> Comment
}
