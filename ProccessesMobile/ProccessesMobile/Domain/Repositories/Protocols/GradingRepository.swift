//
//  GradingRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

protocol GradingRepository: Sendable {
    func gradeSolution(_ command: GradeSolutionCommand) async throws -> Solution
    func removeGrade(_ command: RemoveGradeCommand) async throws -> Solution
}
