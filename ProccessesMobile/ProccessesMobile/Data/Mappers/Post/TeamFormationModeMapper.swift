//
//  TeamFormationModeMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 14.05.2026.
//


enum TeamFormationModeMapper {
    static func toDTO(_ domain: TeamFormationMode) -> TeamFormationModeDTO {
        switch domain {
        case .free:
            return .free
        case .draft:
            return .draft
        case .randomShuffle:
            return .randomShuffle
        case .captainSelection:
            return .captainSelection
        }
    }

    static func toDomain(_ dto: TeamFormationModeDTO) -> TeamFormationMode {
        switch dto {
        case .free:
            return .free
        case .draft:
            return .draft
        case .randomShuffle:
            return .randomShuffle
        case .captainSelection:
            return .captainSelection
        }
    }
}
