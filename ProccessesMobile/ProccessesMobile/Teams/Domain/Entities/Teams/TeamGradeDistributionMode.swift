//
//  TeamGradeDistributionMode.swift
//  ProccessesMobile
//
//  Created by Codex on 20.05.2026.
//

import Foundation

enum TeamGradeDistributionMode: String, Codable, Equatable, Sendable {
    case manual = "MANUAL"
    case autoEqual = "AUTO_EQUAL"
    case captainManual = "CAPTAIN_MANUAL"
    case teamVote = "TEAM_VOTE"

    init(apiValue: String?) {
        self = TeamGradeDistributionMode(rawValue: apiValue ?? "") ?? .manual
    }

    var title: String {
        switch self {
        case .manual:
            return "Manual"
        case .autoEqual:
            return "Auto equal"
        case .captainManual:
            return "Captain manual"
        case .teamVote:
            return "Team vote"
        }
    }
}
