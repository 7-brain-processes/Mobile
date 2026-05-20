//
//  UpdateTeamGradeDistributionCommand.swift
//  ProccessesMobile
//
//  Created by Codex on 20.05.2026.
//

import Foundation

struct UpdateTeamGradeDistributionCommand: Equatable, Sendable {
    let courseId: UUID
    let postId: UUID
    let teamId: UUID
    let distributionMode: TeamGradeDistributionMode
}
