//
//  UpdateTeamGradeCommand.swift
//  ProccessesMobile
//
//  Created by Codex on 20.05.2026.
//

import Foundation

struct UpdateTeamGradeCommand: Equatable, Sendable {
    let courseId: UUID
    let postId: UUID
    let teamId: UUID
    let grade: Int
    let comment: String?
}
