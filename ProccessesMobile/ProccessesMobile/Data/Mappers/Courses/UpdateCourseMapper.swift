//
//  UpdateCourseMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//

import Foundation

enum UpdateCourseMapper {
    static func toCommand(
        _ dto: UpdateCourseRequestDTO,
        courseId: UUID
    ) -> UpdateCourseCommand {
        UpdateCourseCommand(
            courseId: courseId,
            name: dto.name,
            description: dto.description
        )
    }

    static func toDTO(_ command: UpdateCourseCommand) -> UpdateCourseRequestDTO {
        UpdateCourseRequestDTO(
            name: command.name,
            description: command.description
        )
    }
}
