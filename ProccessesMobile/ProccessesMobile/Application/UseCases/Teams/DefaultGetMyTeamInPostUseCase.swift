//
//  DefaultGetMyTeamInPostUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 19.05.2026.
//


import Foundation

struct DefaultGetMyTeamInPostUseCase: GetMyTeamInPostUseCase {
    private let repository: PostTeamsRepository

    init(repository: PostTeamsRepository) {
        self.repository = repository
    }

    func execute(_ query: GetMyTeamInPostQuery) async throws -> StudentTeam {
        try await repository.getMyTeam(query)
    }
}
