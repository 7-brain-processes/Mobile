//
//  GradingRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


protocol GradingRepository: Sendable {
    func gradeSolution(courseId: String, postId: String, solutionId: String, request: GradeRequest) async throws -> Solution
}
