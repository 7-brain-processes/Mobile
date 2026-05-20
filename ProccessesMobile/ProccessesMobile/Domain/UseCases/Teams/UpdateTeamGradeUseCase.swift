//
//  UpdateTeamGradeUseCase.swift
//  ProccessesMobile
//
//  Created by Codex on 20.05.2026.
//

import Foundation

protocol UpdateTeamGradeUseCase {
    func execute(_ command: UpdateTeamGradeCommand) async throws -> TeamGrade
}
