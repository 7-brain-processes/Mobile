//
//  CreateTeamRequirementTemplateMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 14.05.2026.
//


import Foundation

enum CreateTeamRequirementTemplateMapper {
    static func toDTO(
        _ command: CreateTeamRequirementTemplateCommand
    ) -> CreateTeamRequirementTemplateRequestDTO {
        CreateTeamRequirementTemplateRequestDTO(
            name: command.name,
            description: command.description,
            minTeamSize: command.minTeamSize,
            maxTeamSize: command.maxTeamSize,
            requiredCategoryId: command.requiredCategoryId?.uuidString,
            requireAudio: command.requireAudio,
            requireVideo: command.requireVideo
        )
    }
}