//
//  CreateSolutionCommentMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//


enum CreateSolutionCommentMapper {
    static func toDTO(_ command: CreateSolutionCommentCommand) -> CreateCommentRequestDTO {
        CreateCommentRequestDTO(text: command.text)
    }
}