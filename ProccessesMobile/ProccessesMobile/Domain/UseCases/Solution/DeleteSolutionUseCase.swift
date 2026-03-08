//
//  DeleteSolutionUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

typealias DeleteSolutionCommand = SolutionOfPost

protocol DeleteSolutionUseCase: Sendable {
    func execute(_ command: DeleteSolutionCommand) async throws
}
