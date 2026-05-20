//
//  AssessmentConfigMapper.swift
//  ProccessesMobile
//

import Foundation

enum AssessmentConfigMapper {
    static func toDomain(_ dto: GradingConfigResponseDTO) throws -> AssessmentConfig {
        AssessmentConfig(
            id: try dto.id.map(parseUUID),
            maxGrade: dto.maxGrade,
            criteria: try dto.criteria.map(CriterionConfigMapper.toDomain),
            modifiers: try dto.modifiers.map(ModifierConfigMapper.toDomain),
            resultsVisible: dto.resultsVisible
        )
    }

    static func toDTO(_ config: AssessmentConfig) -> UpsertGradingConfigRequestDTO {
        UpsertGradingConfigRequestDTO(
            maxGrade: config.maxGrade,
            criteria: config.criteria.map(CriterionConfigMapper.toDTO),
            modifiers: config.modifiers.map(ModifierConfigMapper.toDTO),
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
            weight: dto.weight,
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
            commentEnabled: criterion.commentEnabled
        )
    }
}

enum ModifierConfigMapper {
    static func toDomain(_ dto: ModifierConfigDTO) throws -> AssessmentModifier {
        AssessmentModifier(
            id: try dto.id.map(parseUUID),
            type: ModifierType(apiValue: dto.type),
            enabled: dto.enabled ?? true
        )
    }

    static func toDTO(_ modifier: AssessmentModifier) -> ModifierConfigDTO {
        ModifierConfigDTO(
            id: modifier.id?.uuidString,
            title: nil,
            type: modifier.type.apiValue,
            enabled: modifier.enabled,
            weight: nil
        )
    }
}
