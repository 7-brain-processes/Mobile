//
//  DefaultListTeamRequirementTemplatesUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 14.05.2026.
//

import Foundation

struct DefaultListTeamRequirementTemplatesUseCase: ListTeamRequirementTemplatesUseCase {
    let repository: TeamRequirementTemplateRepository

    func execute(courseId: UUID) async throws -> [TeamRequirementTemplate] {
        try await repository.listTemplates(courseId: courseId)
    }
}
