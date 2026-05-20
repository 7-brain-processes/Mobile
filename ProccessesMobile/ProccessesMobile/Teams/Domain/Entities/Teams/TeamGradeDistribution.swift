//
//  TeamGradeDistribution.swift
//  ProccessesMobile
//
//  Created by Codex on 20.05.2026.
//

import Foundation

struct TeamGradeDistribution: Equatable, Sendable {
    let teamId: UUID
    let teamGrade: Int?
    let distributionMode: TeamGradeDistributionMode
    let students: [StudentDistributedGrade]
}
