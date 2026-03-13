//
//  AuthResponseMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//

enum AuthResponseMapper {
    static func toDomain(_ dto: AuthResponseDTO) throws -> AuthResponse {
        AuthResponse(
            token: dto.token,
            user: try UserMapper.toDomain(dto.user)
        )
    }
}
