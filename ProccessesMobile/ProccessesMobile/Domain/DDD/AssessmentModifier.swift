//
//  AssessmentModifier.swift
//  ProccessesMobile
//

import Foundation

struct AssessmentModifier: Equatable, Sendable {
    let id: UUID?
    let type: ModifierType
    let enabled: Bool
    let softDeadline: String?
    let hardDeadline: String?
    let softDeadlineBonus: Double?
    let earlySubmissionBonusPerDay: Double?
    let latePenaltyPerDay: Double?
    let maxLatePenaltyDays: Int?
    let formula: String?
    let checkpointCount: Int?
    let pointsPerCheckpoint: Double?
    let description: String?

    init(
        id: UUID? = nil,
        type: ModifierType,
        enabled: Bool,
        softDeadline: String? = nil,
        hardDeadline: String? = nil,
        softDeadlineBonus: Double? = nil,
        earlySubmissionBonusPerDay: Double? = nil,
        latePenaltyPerDay: Double? = nil,
        maxLatePenaltyDays: Int? = nil,
        formula: String? = nil,
        checkpointCount: Int? = nil,
        pointsPerCheckpoint: Double? = nil,
        description: String? = nil
    ) {
        self.id = id
        self.type = type
        self.enabled = enabled
        self.softDeadline = softDeadline
        self.hardDeadline = hardDeadline
        self.softDeadlineBonus = softDeadlineBonus
        self.earlySubmissionBonusPerDay = earlySubmissionBonusPerDay
        self.latePenaltyPerDay = latePenaltyPerDay
        self.maxLatePenaltyDays = maxLatePenaltyDays
        self.formula = formula
        self.checkpointCount = checkpointCount
        self.pointsPerCheckpoint = pointsPerCheckpoint
        self.description = description
    }
}
