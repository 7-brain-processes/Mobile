//
//  ListSolutionsUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public protocol ListSolutionsUseCase: Sendable {
    func execute(courseId: String, postId: String, page: Int, size: Int, status: SolutionStatus?) async throws -> PageSolution
}