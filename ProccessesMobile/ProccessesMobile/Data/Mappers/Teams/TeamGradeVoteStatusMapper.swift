//
//  TeamGradeVoteStatusMapper.swift
//  ProccessesMobile
//
//  Created by Codex on 20.05.2026.
//

import Foundation

enum TeamGradeVoteStatusMapper {
    static func toDomain(_ dto: TeamGradeVoteStatusDTO) throws -> TeamGradeVoteStatus {
        guard let rawTeamId = dto.teamId else {
            throw MappingError.invalidUUID(field: "teamId", value: "nil")
        }

        return TeamGradeVoteStatus(
            teamId: try parseUUID(rawTeamId),
            teamGrade: dto.teamGrade,
            finalized: dto.finalized ?? false,
            voters: try mapVoters(dto.voters ?? []),
            myVote: try mapStudents(dto.myVote ?? []),
            finalDistribution: try mapStudents(dto.finalDistribution ?? [])
        )
    }

    static func toDTO(
        _ command: SubmitTeamGradeVoteCommand
    ) -> CaptainGradeDistributionRequestDTO {
        CaptainGradeDistributionRequestDTO(
            grades: command.grades.map {
                CaptainStudentGradeEntryDTO(
                    studentId: $0.studentId.uuidString,
                    grade: $0.grade
                )
            }
        )
    }

    private static func mapVoters(_ dtos: [VoterStatusDTO]) throws -> [VoterStatus] {
        var result: [VoterStatus] = []

        for dto in dtos {
            guard let userDTO = dto.user else { continue }

            result.append(
                VoterStatus(
                    user: try UserMapper.toDomain(userDTO),
                    hasVoted: dto.hasVoted ?? false
                )
            )
        }

        return result
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
