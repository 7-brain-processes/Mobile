//
//  GradeRequestDTO.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 18.05.2026.
//

import Foundation

struct GradeRequestDTO: Equatable, Sendable, Codable {
    let grade: Int
    let comment: String?
}
