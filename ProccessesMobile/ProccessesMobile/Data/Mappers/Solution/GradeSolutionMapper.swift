//
//  GradeSolutionMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//


enum GradeSolutionMapper {
    static func toDTO(_ command: GradeSolutionCommand) -> GradeRequestDTO {
        GradeRequestDTO(
            grade: command.grade,
            comment: command.comment
        )
    }
}