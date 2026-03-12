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
