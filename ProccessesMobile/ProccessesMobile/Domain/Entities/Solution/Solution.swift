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
    
    init(id: UUID, text: String?, status: SolutionStatus, grade: Int?, filesCount: Int, student: User?, submittedAt: Date, updatedAt: Date, gradedAt: Date?) {
        self.id = id
        self.text = text
        self.status = status
        self.grade = grade
        self.filesCount = filesCount
        self.student = student
        self.submittedAt = submittedAt
        self.updatedAt = updatedAt
        self.gradedAt = gradedAt
    }
}
