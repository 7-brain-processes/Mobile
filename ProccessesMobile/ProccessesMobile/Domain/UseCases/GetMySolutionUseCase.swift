//
//  GetMySolutionUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


protocol GetMySolutionUseCase: Sendable {
    func execute(courseId: String, postId: String) async throws -> Solution
}