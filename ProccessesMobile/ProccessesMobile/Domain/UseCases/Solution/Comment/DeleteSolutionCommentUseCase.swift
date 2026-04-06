//
//  DeleteSolutionCommentUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

protocol DeleteSolutionCommentUseCase: Sendable {
    func execute(_ command: DeleteSolutionCommentCommand) async throws
}
