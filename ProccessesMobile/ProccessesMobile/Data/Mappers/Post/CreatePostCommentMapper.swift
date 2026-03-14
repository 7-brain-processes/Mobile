//
//  CreatePostCommentMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//


enum CreatePostCommentMapper {
    static func toDTO(_ command: CreatePostCommentCommand) -> CreateCommentRequestDTO {
        CreateCommentRequestDTO(text: command.text)
    }
}