//
//  CreatePostTeamMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 20.05.2026.
//

import Foundation

enum CreatePostTeamMapper {
    static func toDTO(_ command: CreatePostTeamCommand) -> CreatePostTeamRequestDTO {
        CreatePostTeamRequestDTO(
            name: command.name,
            maxSize: command.maxSize,
            selfEnrollmentEnabled: command.selfEnrollmentEnabled
        )
    }
}
