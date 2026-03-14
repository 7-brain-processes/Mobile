//
//  ListSolutionCommentsUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

protocol ListSolutionCommentsUseCase: Sendable {
    func execute(_ query: ListSolutionCommentsQuery) async throws -> Page<Comment>
}
