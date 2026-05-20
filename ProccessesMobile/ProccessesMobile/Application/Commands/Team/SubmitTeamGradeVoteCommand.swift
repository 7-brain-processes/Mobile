//
//  SubmitTeamGradeVoteCommand.swift
//  ProccessesMobile
//
//  Created by Codex on 20.05.2026.
//

import Foundation

struct SubmitTeamGradeVoteCommand: Equatable, Sendable {
    let courseId: UUID
    let postId: UUID
    let grades: [StudentGradeVoteEntry]
}
