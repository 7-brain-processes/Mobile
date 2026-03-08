//
//  CreateInviteCommand.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct CreateInviteCommand: Equatable, Sendable {
    let courseId: UUID
    let role: CourseRole
    let expiresAt: Date?
    let maxUses: Int?
}

extension CreateInviteCommand {

    func toDTO() -> CreateInviteRequestDTO {
        CreateInviteRequestDTO(
            role: role.toDTO(),
            expiresAt: expiresAt.map(formatDate),
            maxUses: maxUses
        )
    }
}
