//
//  GradeCommand.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct GradeSolutionCommand: Equatable, Sendable {
    let courseId: UUID
    let postId: UUID
    let solutionId: UUID
    let grade: Int
    let comment: String?
}

extension GradeSolutionCommand {
    func toDTO() -> GradeRequestDTO {
        GradeRequestDTO(
            grade: grade,
            comment: comment
        )
    }
}
