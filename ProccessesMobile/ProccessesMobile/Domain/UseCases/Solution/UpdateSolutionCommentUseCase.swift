//
//  UpdateSolutionCommentUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


protocol UpdateSolutionCommentUseCase: Sendable {
    func execute(_ command: UpdateSolutionCommentCommand) async throws -> Comment
}
