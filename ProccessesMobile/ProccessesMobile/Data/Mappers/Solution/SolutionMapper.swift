//
//  SolutionMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//

import Foundation

enum SolutionMapper {
    static func toDomain(_ dto: SolutionDTO) throws -> Solution {
        Solution(
            id: try parseUUID(dto.id),
            text: dto.text,
            status: SolutionStatusMapper.toDomain(dto.status),
            grade: dto.grade,
            filesCount: dto.filesCount,
            student: try dto.student.map(UserMapper.toDomain),
            submittedAt: try parseDate(dto.submittedAt),
            updatedAt: try parseDate(dto.updatedAt),
            gradedAt: try dto.gradedAt.map(parseDate)
        )
    }
}
