//
//  CreateInviteMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//


enum CreateInviteMapper {
    static func toDTO(_ command: CreateInviteCommand) -> CreateInviteRequestDTO {
        CreateInviteRequestDTO(
            role: CourseRoleMapper.toDTO(command.role),
            expiresAt: command.expiresAt.map(formatDate),
            maxUses: command.maxUses
        )
    }
}
