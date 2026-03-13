//
//  LoginMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//

enum LoginMapper {
    static func toDTO(_ command: LoginCommand) -> LoginRequestDTO {
        LoginRequestDTO(
            username: command.username,
            password: command.password
        )
    }
}
