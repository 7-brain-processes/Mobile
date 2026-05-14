//
//  TeamRequirementTemplateRepository.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 14.05.2026.
//


import Foundation

protocol TeamRequirementTemplateRepository: Sendable {
    func listTemplates(courseId: UUID) async throws -> [TeamRequirementTemplate]

    func createTemplate(
        _ command: CreateTeamRequirementTemplateCommand
    ) async throws -> TeamRequirementTemplate
}