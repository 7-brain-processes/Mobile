//
//  ModifierType.swift
//  ProccessesMobile
//

import Foundation

enum ModifierType: Equatable, Sendable {
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
        case "PROGRESS":
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
            return "PROGRESS"
        case .contribution:
            return "CONTRIBUTION"
        case .unknown(let value):
            return value
        }
    }
}
