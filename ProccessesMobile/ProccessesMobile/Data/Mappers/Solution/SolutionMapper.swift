//
//  SolutionMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//

import Foundation

extension SolutionDTO {
    func toDomain() throws -> Solution {
        Solution(
            id: try parseUUID(id),
            text: text,
            status: status.toDomain(),
            grade: grade,
            filesCount: filesCount,
            student: try student?.toDomain(),
            submittedAt: try parseDate(submittedAt),
            updatedAt: try parseDate(updatedAt),
            gradedAt: try gradedAt.map(parseDate)
        )
    }
}

extension SolutionStatusDTO {
    func toDomain() -> SolutionStatus {
        switch self {
        case .submitted: return .submitted
        case .graded: return .graded
        }
    }
}


extension SolutionStatus {
    func toDTO() -> SolutionStatusDTO {
        switch self {
        case .submitted: return .submitted
        case .graded: return .graded
        }
    }
}
