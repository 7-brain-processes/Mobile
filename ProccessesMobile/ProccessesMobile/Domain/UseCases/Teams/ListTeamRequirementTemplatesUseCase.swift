//
//  ListTeamRequirementTemplatesUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 14.05.2026.
//


import Foundation

protocol ListTeamRequirementTemplatesUseCase: Sendable {
    func execute(courseId: UUID) async throws -> [TeamRequirementTemplate]
}

