//
//  DefaultGetMySolutionUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//


import Foundation

struct DefaultGetMySolutionUseCase: GetMySolutionUseCase {
    private let repository: SolutionRepository

    init(repository: SolutionRepository) {
        self.repository = repository
    }

    func execute(_ query: GetMySolutionQuery) async throws -> Solution {
        try await repository.getMySolution(query)
    }
}
