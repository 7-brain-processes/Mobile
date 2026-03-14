//
//  CreateCourseMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//


enum CreateCourseMapper {
    static func toDTO(_ command: CreateCourseCommand) -> CreateCourseRequestDTO {
        CreateCourseRequestDTO(
            name: command.name,
            description: command.description
        )
    }
}