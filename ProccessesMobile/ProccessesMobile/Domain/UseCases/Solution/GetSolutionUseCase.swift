//
//  GetSolutionUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

protocol GetSolutionUseCase: Sendable {
    func execute(courseId: UUID, postId: UUID, solutionId: UUID) async throws -> Solution
}
