//
//  CaptainStudentGradeEntryDTO.swift
//  ProccessesMobile
//
//  Created by Codex on 20.05.2026.
//

import Foundation

struct CaptainStudentGradeEntryDTO: Codable, Equatable, Sendable {
    let studentId: String
    let grade: Int
}
