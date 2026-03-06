//
//  Solution.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public struct Solution: Equatable, Sendable, Codable {
    public let id: String
    public let text: String?
    public let status: SolutionStatus
    public let grade: Int?
    public let filesCount: Int
    public let student: User?
    public let submittedAt: String
    public let updatedAt: String
    public let gradedAt: String?
    
    public init(id: String, text: String?, status: SolutionStatus, grade: Int?, filesCount: Int, student: User?, submittedAt: String, updatedAt: String, gradedAt: String?) {
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