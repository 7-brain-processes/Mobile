//
//  CreatePostMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//

import Foundation

enum CreatePostMapper {
    static func toDTO(_ command: CreatePostCommand) -> CreatePostRequestDTO {
        CreatePostRequestDTO(
            title: command.title,
            content: command.content,
            type: PostTypeMapper.toDTO(command.type),
            teamFormationMode: command.teamFormationMode.map(TeamFormationModeMapper.toDTO),
            teamRequirementTemplateId: command.teamRequirementTemplateId?.uuidString,
            deadline: command.deadline.map(formatDate)
        )
    }
}
