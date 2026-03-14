//
//  UpdateSolutionMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//


enum UpdateSolutionMapper {
    static func toDTO(_ command: UpdateSolutionCommand) -> CreateSolutionRequestDTO {
        CreateSolutionRequestDTO(
            text: command.text
        )
    }
}