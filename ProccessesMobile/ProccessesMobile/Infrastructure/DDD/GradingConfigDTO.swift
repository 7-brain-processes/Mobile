//
//  GradingConfigDTO.swift
//  ProccessesMobile
//

import Foundation

struct UpsertGradingConfigRequestDTO: Equatable, Sendable, Codable {
    let maxGrade: Double
    let criteria: [CriterionConfigDTO]
    let modifiers: ModifierConfigDTO?
    let resultsVisible: Bool
}

struct GradingConfigResponseDTO: Equatable, Sendable, Codable {
    let postId: String?
    let maxGrade: Double
    let criteria: [CriterionConfigDTO]
    let modifiers: ModifierConfigDTO?
    let resultsVisible: Bool
    let createdAt: String?
    let updatedAt: String?
}

struct CriterionConfigDTO: Equatable, Sendable, Codable {
    let id: String?
    let title: String
    let type: String
    let maxPoints: Double
    let weight: Double?
    let sortOrder: Int?
    let commentEnabled: Bool?
}

struct ModifierConfigDTO: Equatable, Sendable, Codable {
    let deadlines: DeadlineModifierDTO?
    let teamSize: TeamSizeModifierDTO?
    let progressRegularity: ProgressRegularityModifierDTO?
    let contributionVoting: ContributionModifierDTO?
}

struct DeadlineModifierDTO: Equatable, Sendable, Codable {
    let enabled: Bool?
    let softDeadline: String?
    let hardDeadline: String?
    let softDeadlineBonus: Double?
    let earlySubmissionBonusPerDay: Double?
    let latePenaltyPerDay: Double?
    let maxLatePenaltyDays: Int?
}

struct TeamSizeModifierDTO: Equatable, Sendable, Codable {
    let enabled: Bool?
    let formula: String?
}

struct ProgressRegularityModifierDTO: Equatable, Sendable, Codable {
    let enabled: Bool?
    let checkpointCount: Int?
    let pointsPerCheckpoint: Double?
}

struct ContributionModifierDTO: Equatable, Sendable, Codable {
    let enabled: Bool?
    let description: String?
}
