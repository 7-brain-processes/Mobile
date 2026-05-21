//
//  GradeBreakdownMapper.swift
//  ProccessesMobile
//

import Foundation

enum GradeBreakdownMapper {
    static func toDomain(_ dto: GradeDecompositionResponseDTO) throws -> GradeBreakdown {
        GradeBreakdown(
            basicScore: dto.basicScore,
            modifierDelta: nil,
            finalScore: dto.finalScore,
            criteria: try dto.criteriaBreakdown.map(CriterionBreakdownMapper.toDomain),
            modifiers: dto.modifierEffects.map(ModifierBreakdownMapper.toDomain)
        )
    }
}

enum CriterionBreakdownMapper {
    static func toDomain(_ dto: CriterionGradeResultItemDTO) throws -> CriterionBreakdownItem {
        CriterionBreakdownItem(
            criterionId: try dto.criterion.id.map(parseUUID),
            title: dto.criterion.title,
            type: CriterionType(apiValue: dto.criterion.type),
            value: dto.value,
            score: dto.computedPoints,
            comment: dto.comment
        )
    }
}

enum ModifierBreakdownMapper {
    static func toDomain(_ dto: ModifierEffectDTO) -> ModifierBreakdownItem {
        let type = ModifierType(apiValue: dto.modifierType)

        return ModifierBreakdownItem(
            type: type,
            title: type.apiValue,
            effect: dto.delta,
            description: dto.description
        )
    }
}
