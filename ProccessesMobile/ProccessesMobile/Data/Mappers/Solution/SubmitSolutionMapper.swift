//
//  SubmitSolutionMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//


enum SubmitSolutionMapper {
    static func toDTO(_ command: SubmitSolutionCommand) -> CreateSolutionRequestDTO {
        CreateSolutionRequestDTO(text: command.text)
    }
}
