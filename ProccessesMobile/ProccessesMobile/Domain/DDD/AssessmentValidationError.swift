//
//  AssessmentValidationError.swift
//  ProccessesMobile
//

import Foundation

enum AssessmentValidationError: LocalizedError, Equatable, Sendable {
    case emptyCriterionTitle
    case invalidMaxGrade
    case invalidMaxPoints
    case percentOutOfRange(min: Double, max: Double)
    case pointsAboveMaximum(maxPoints: Double)
    case invalidBooleanValue
    case emptyCriteriaRequired

    var errorDescription: String? {
        switch self {
        case .emptyCriterionTitle:
            return "Criterion title cannot be empty."
        case .invalidMaxGrade:
            return "Maximum grade must be greater than zero."
        case .invalidMaxPoints:
            return "Criterion maximum points must be greater than zero."
        case .percentOutOfRange(let min, let max):
            return "Percent value must be between \(format(min)) and \(format(max))."
        case .pointsAboveMaximum(let maxPoints):
            return "Criterion points cannot exceed \(format(maxPoints))."
        case .invalidBooleanValue:
            return "Boolean criterion value must be 0 or 1."
        case .emptyCriteriaRequired:
            return "At least one criterion is required."
        }
    }

    private func format(_ value: Double) -> String {
        value.formatted(.number.precision(.fractionLength(0...2)))
    }
}
