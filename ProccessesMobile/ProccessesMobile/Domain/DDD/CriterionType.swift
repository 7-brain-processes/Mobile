//
//  CriterionType.swift
//  ProccessesMobile
//

import Foundation

enum CriterionType: Equatable, Sendable {
    case boolean
    case percent
    case points
    case unknown(String)

    init(apiValue: String) {
        switch apiValue.uppercased() {
        case "BOOLEAN":
            self = .boolean
        case "PERCENT":
            self = .percent
        case "POINTS":
            self = .points
        default:
            self = .unknown(apiValue)
        }
    }

    var apiValue: String {
        switch self {
        case .boolean:
            return "BOOLEAN"
        case .percent:
            return "PERCENT"
        case .points:
            return "POINTS"
        case .unknown(let value):
            return value
        }
    }
}
