//
//  AssessmentConfigMapper.swift
//  ProccessesMobile
//

import Foundation

enum AssessmentConfigMapper {
    static func toDomain(_ dto: GradingConfigResponseDTO) throws -> AssessmentConfig {
        AssessmentConfig(
            id: try dto.postId.map(parseUUID),
            maxGrade: dto.maxGrade,
            criteria: try dto.criteria.map(CriterionConfigMapper.toDomain),
            modifiers: dto.modifiers.map(ModifierConfigMapper.toDomain) ?? [],
            resultsVisible: dto.resultsVisible
        )
    }

    static func toDTO(_ config: AssessmentConfig) -> UpsertGradingConfigRequestDTO {
        UpsertGradingConfigRequestDTO(
            maxGrade: config.maxGrade,
            criteria: config.criteria.map(CriterionConfigMapper.toDTO),
            modifiers: ModifierConfigMapper.toDTO(config.modifiers),
            resultsVisible: config.resultsVisible
        )
    }
}

enum CriterionConfigMapper {
    static func toDomain(_ dto: CriterionConfigDTO) throws -> AssessmentCriterion {
        AssessmentCriterion(
            id: try dto.id.map(parseUUID),
            title: dto.title,
            type: CriterionType(apiValue: dto.type),
            maxPoints: dto.maxPoints,
            weight: dto.weight ?? 1,
            commentEnabled: dto.commentEnabled ?? false
        )
    }

    static func toDTO(_ criterion: AssessmentCriterion) -> CriterionConfigDTO {
        CriterionConfigDTO(
            id: criterion.id?.uuidString,
            title: criterion.title,
            type: criterion.type.apiValue,
            maxPoints: criterion.maxPoints,
            weight: criterion.weight,
            sortOrder: nil,
            commentEnabled: criterion.commentEnabled
        )
    }
}

enum ModifierConfigMapper {
    static func toDomain(_ dto: ModifierConfigDTO) -> [AssessmentModifier] {
        var modifiers: [AssessmentModifier] = []

        if let deadlines = dto.deadlines {
            modifiers.append(
                AssessmentModifier(
                    type: .deadline,
                    enabled: deadlines.enabled ?? false,
                    softDeadline: deadlines.softDeadline,
                    hardDeadline: deadlines.hardDeadline,
                    softDeadlineBonus: deadlines.softDeadlineBonus,
                    earlySubmissionBonusPerDay: deadlines.earlySubmissionBonusPerDay,
                    latePenaltyPerDay: deadlines.latePenaltyPerDay,
                    maxLatePenaltyDays: deadlines.maxLatePenaltyDays
                )
            )
        }

        if let teamSize = dto.teamSize {
            modifiers.append(
                AssessmentModifier(
                    type: .teamSize,
                    enabled: teamSize.enabled ?? false,
                    formula: teamSize.formula
                )
            )
        }

        if let progressRegularity = dto.progressRegularity {
            modifiers.append(
                AssessmentModifier(
                    type: .progress,
                    enabled: progressRegularity.enabled ?? false,
                    checkpointCount: progressRegularity.checkpointCount,
                    pointsPerCheckpoint: progressRegularity.pointsPerCheckpoint
                )
            )
        }

        if let contributionVoting = dto.contributionVoting {
            modifiers.append(
                AssessmentModifier(
                    type: .contribution,
                    enabled: contributionVoting.enabled ?? false,
                    description: contributionVoting.description
                )
            )
        }

        return modifiers
    }

    static func toDTO(_ modifiers: [AssessmentModifier]) -> ModifierConfigDTO? {
        guard !modifiers.isEmpty else { return nil }

        func modifier(_ type: ModifierType) -> AssessmentModifier? {
            modifiers.first { $0.type == type }
        }

        return ModifierConfigDTO(
            deadlines: modifier(.deadline).map {
                DeadlineModifierDTO(
                    enabled: $0.enabled,
                    softDeadline: $0.softDeadline,
                    hardDeadline: $0.hardDeadline,
                    softDeadlineBonus: $0.softDeadlineBonus,
                    earlySubmissionBonusPerDay: $0.earlySubmissionBonusPerDay,
                    latePenaltyPerDay: $0.latePenaltyPerDay,
                    maxLatePenaltyDays: $0.maxLatePenaltyDays
                )
            },
            teamSize: modifier(.teamSize).map {
                TeamSizeModifierDTO(enabled: $0.enabled, formula: $0.formula)
            },
            progressRegularity: modifier(.progress).map {
                ProgressRegularityModifierDTO(
                    enabled: $0.enabled,
                    checkpointCount: $0.checkpointCount,
                    pointsPerCheckpoint: $0.pointsPerCheckpoint
                )
            },
            contributionVoting: modifier(.contribution).map {
                ContributionModifierDTO(enabled: $0.enabled, description: $0.description)
            }
        )
    }
}
