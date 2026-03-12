//
//  UpdateSolutionCommentMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//


enum UpdateSolutionCommentMapper {
    static func toDTO(_ command: UpdateSolutionCommentCommand) -> CreateCommentRequestDTO {
        CreateCommentRequestDTO(text: command.text)
    }
}