//
//  EnrollmentResponseMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 19.05.2026.
//


import Foundation

enum EnrollmentResponseMapper {
    static func toDomain(_ dto: EnrollmentResponseDTO) throws -> EnrollmentResponse {
        EnrollmentResponse(
            success: dto.success,
            message: dto.message,
            team: try dto.team.map(TeamEnrollmentStatusMapper.toDomain)
        )
    }
}
