//
//  Solution.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct Solution: Equatable, Sendable, Codable {
    let id: UUID
    let text: String?
    let status: SolutionStatus
    let grade: Int?
    let filesCount: Int
    let student: User?
    let submittedAt: Date
    let updatedAt: Date
    let gradedAt: Date?
}
