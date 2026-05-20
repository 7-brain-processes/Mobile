//
//  CreateTeamRequirementTemplateUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 14.05.2026.
//


import Foundation

protocol CreateTeamRequirementTemplateUseCase: Sendable {
    func execute(
        _ command: CreateTeamRequirementTemplateCommand
    ) async throws -> TeamRequirementTemplate
}
