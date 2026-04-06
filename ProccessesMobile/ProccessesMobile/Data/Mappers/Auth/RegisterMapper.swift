//
//  RegisterMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//

enum RegisterMapper {
    static func toDTO(_ command: RegisterCommand) -> RegisterRequestDTO {
        RegisterRequestDTO(
            username: command.username,
            password: command.password,
            displayName: command.displayName
        )
    }
}
