//
//  StudentGradeVoteEntry.swift
//  ProccessesMobile
//
//  Created by Codex on 20.05.2026.
//

import Foundation

struct StudentGradeVoteEntry: Equatable, Sendable {
    let studentId: UUID
    let grade: Int
}
