//
//  ModifierType.swift
//  ProccessesMobile
//

import Foundation

enum ModifierType: Equatable, Hashable, Sendable {
    case deadline
    case teamSize
    case progress
    case contribution
    case unknown(String)

    init(apiValue: String) {
        switch apiValue.uppercased() {
        case "DEADLINE":
            self = .deadline
        case "TEAM_SIZE":
            self = .teamSize
        case "PROGRESS", "PROGRESS_REGULARITY":
            self = .progress
        case "CONTRIBUTION":
            self = .contribution
        default:
            self = .unknown(apiValue)
        }
    }

    var apiValue: String {
        switch self {
        case .deadline:
            return "DEADLINE"
        case .teamSize:
            return "TEAM_SIZE"
        case .progress:
            return "PROGRESS_REGULARITY"
        case .contribution:
            return "CONTRIBUTION"
        case .unknown(let value):
            return value
        }
    }

    static let supportedCases: [ModifierType] = [
           .deadline,
           .teamSize,
           .progress,
           .contribution
       ]

    var displayName: String {
        switch self {
        case .deadline:
            return "Deadline"
        case .teamSize:
            return "Team size"
        case .progress:
            return "Progress regularity"
        case .contribution:
            return "Contribution"
        case .unknown(let value):
            return value.capitalized
        }
    }
}
