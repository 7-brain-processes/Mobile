//
//  TeamGradeDistributionDTO.swift
//  ProccessesMobile
//
//  Created by Codex on 20.05.2026.
//

import Foundation

struct TeamGradeDistributionDTO: Decodable, Equatable, Sendable {
    let teamId: String?
    let teamGrade: Int?
    let distributionMode: String?
    let students: [StudentDistributedGradeDTO]?
}
