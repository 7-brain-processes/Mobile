//
//  SolutionRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

protocol SolutionRepository: Sendable {
    func listSolutions(_ query: ListSolutionsQuery) async throws -> Page<Solution>
    func submitSolution(_ command: SubmitSolutionCommand) async throws -> Solution
    func getMySolution(_ command: GetMySolutionQuery) async throws -> Solution
    func getSolution(_ command: SolutionOfPost) async throws -> Solution
    func updateSolution(_ command: UpdateSolutionCommand) async throws -> Solution
    func deleteSolution(_ command: SolutionOfPost) async throws
}
