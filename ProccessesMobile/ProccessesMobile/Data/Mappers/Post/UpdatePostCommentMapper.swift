//
//  UpdatePostCommentMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//


enum UpdatePostCommentMapper {
    static func toDTO(_ command: UpdatePostCommentCommand) -> CreateCommentRequestDTO {
        CreateCommentRequestDTO(
            text: command.text
        )
    }
}