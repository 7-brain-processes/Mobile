//
//  GetMySolutionUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

protocol GetMySolutionUseCase: Sendable {
    func execute(_ query: GetMySolutionQuery) async throws -> Solution
}

// TODO:
struct GetMySolutionQuery: Equatable, Sendable {
    let courseId: UUID
    let postId: UUID
}
