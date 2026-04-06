//
//  Solution.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

struct SolutionDTO: Equatable, Sendable, Codable {
    let id: String
    let text: String?
    let status: SolutionStatusDTO
    let grade: Int?
    let filesCount: Int
    let student: UserDTO?
    let submittedAt: String
    let updatedAt: String
    let gradedAt: String?
}
