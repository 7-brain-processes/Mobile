//
//  SolutionRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


protocol SolutionRepository: Sendable {
    func listSolutions(courseId: String, postId: String, page: Int, size: Int, status: SolutionStatus?) async throws -> PageSolution
    func submitSolution(courseId: String, postId: String, request: CreateSolutionRequest) async throws -> Solution
    func getMySolution(courseId: String, postId: String) async throws -> Solution
    func getSolution(courseId: String, postId: String, solutionId: String) async throws -> Solution
    func updateSolution(courseId: String, postId: String, solutionId: String, request: CreateSolutionRequest) async throws -> Solution
    func deleteSolution(courseId: String, postId: String, solutionId: String) async throws
}