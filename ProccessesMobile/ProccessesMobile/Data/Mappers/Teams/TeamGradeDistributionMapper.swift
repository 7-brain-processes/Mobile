//
//  TeamGradeDistributionMapper.swift
//  ProccessesMobile
//
//  Created by Codex on 20.05.2026.
//

import Foundation

enum TeamGradeDistributionMapper {
    static func toDomain(_ dto: TeamGradeDistributionDTO) throws -> TeamGradeDistribution {
        guard let rawTeamId = dto.teamId else {
            throw MappingError.invalidUUID(field: "teamId", value: "nil")
        }

        return TeamGradeDistribution(
            teamId: try parseUUID(rawTeamId),
            teamGrade: dto.teamGrade,
            distributionMode: TeamGradeDistributionMode(apiValue: dto.distributionMode),
            students: try mapStudents(dto.students ?? [])
        )
    }

    static func toDTO(
        _ command: UpdateTeamGradeDistributionCommand
    ) -> UpdateTeamGradeDistributionRequestDTO {
        UpdateTeamGradeDistributionRequestDTO(
            distributionMode: command.distributionMode.rawValue
        )
    }

    private static func mapStudents(
        _ dtos: [StudentDistributedGradeDTO]
    ) throws -> [StudentDistributedGrade] {
        var result: [StudentDistributedGrade] = []

        for dto in dtos {
            guard let studentDTO = dto.student else { continue }

            result.append(
                StudentDistributedGrade(
                    student: try UserMapper.toDomain(studentDTO),
                    grade: dto.grade
                )
            )
        }

        return result
    }
}
