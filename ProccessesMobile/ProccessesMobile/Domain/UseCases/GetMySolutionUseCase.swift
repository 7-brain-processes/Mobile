//
//  GetMySolutionUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public protocol GetMySolutionUseCase: Sendable {
    func execute(courseId: String, postId: String) async throws -> Solution
}