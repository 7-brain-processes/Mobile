//
//  UpdatePostMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//


enum UpdatePostMapper {
    static func toDTO(_ command: UpdatePostCommand) -> UpdatePostRequestDTO {
        UpdatePostRequestDTO(
            title: command.title,
            content: command.content,
            deadline: command.deadline.map(formatDate)
        )
    }
}