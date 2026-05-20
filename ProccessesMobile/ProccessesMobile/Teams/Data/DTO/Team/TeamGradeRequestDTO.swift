//
//  TeamGradeRequestDTO.swift
//  ProccessesMobile
//
//  Created by Codex on 20.05.2026.
//

import Foundation

struct TeamGradeRequestDTO: Equatable, Sendable, Codable {
    let grade: Int
    let comment: String?
}
