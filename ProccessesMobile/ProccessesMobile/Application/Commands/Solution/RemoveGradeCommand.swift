//
//  RemoveGradeCommand.swift
//  ProccessesMobile
//
//  Created by dark type on 13.03.2026.
//

import Foundation

struct RemoveGradeCommand: Sendable {
    let courseId: UUID
    let postId: UUID
    let solutionId: UUID
}
