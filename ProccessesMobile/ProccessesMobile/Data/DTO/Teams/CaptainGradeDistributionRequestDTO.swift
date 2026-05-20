//
//  CaptainGradeDistributionRequestDTO.swift
//  ProccessesMobile
//
//  Created by Codex on 20.05.2026.
//

import Foundation

struct CaptainGradeDistributionRequestDTO: Codable, Equatable, Sendable {
    let grades: [CaptainStudentGradeEntryDTO]
}
