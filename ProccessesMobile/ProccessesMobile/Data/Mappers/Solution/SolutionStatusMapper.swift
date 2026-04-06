//
//  SolutionStatusMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//

import Foundation

enum SolutionStatusMapper {
    static func toDomain(_ dto: SolutionStatusDTO) -> SolutionStatus {
        switch dto {
        case .submitted:
            return .submitted
        case .graded:
            return .graded
        }
    }

    static func toDTO(_ domain: SolutionStatus) -> SolutionStatusDTO {
        switch domain {
        case .submitted:
            return .submitted
        case .graded:
            return .graded
        }
    }
}
