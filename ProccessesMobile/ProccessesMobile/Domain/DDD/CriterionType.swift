//
//  CriterionType.swift
//  ProccessesMobile
//

import Foundation

enum CriterionType: Equatable, Hashable, Sendable {
    case yesNo
    case percentage
    case points
    case unknown(String)

    init(apiValue: String) {
        switch apiValue.uppercased() {
        case "YES_NO":
            self = .yesNo

        case "PERCENTAGE":
            self = .percentage

        case "POINTS":
            self = .points

        default:
            self = .unknown(apiValue)
        }
    }

    var apiValue: String {
        switch self {
        case .yesNo:
            return "YES_NO"

        case .percentage:
            return "PERCENTAGE"

        case .points:
            return "POINTS"

        case .unknown(let value):
            return value
        }
    }

    static let supportedCases: [CriterionType] = [
        .yesNo,
        .percentage,
        .points
    ]

    var displayName: String {
        switch self {
        case .yesNo:
            return "Yes / No"

        case .percentage:
            return "Percentage"

        case .points:
            return "Points"

        case .unknown(let value):
            return value.capitalized
        }
    }
}
