//
//  CreatePostMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//


enum CreatePostMapper {
    static func toDTO(_ command: CreatePostCommand) -> CreatePostRequestDTO {
        CreatePostRequestDTO(
            title: command.title,
            content: command.content,
            type: PostTypeMapper.toDTO(command.type),
            deadline: command.deadline.map(formatDate)
        )
    }
}