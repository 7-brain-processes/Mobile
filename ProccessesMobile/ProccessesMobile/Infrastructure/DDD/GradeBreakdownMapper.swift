//
//  GradeBreakdownMapper.swift
//  ProccessesMobile
//

import Foundation

enum GradeBreakdownMapper {
    static func toDomain(_ dto: GradeDecompositionResponseDTO) throws -> GradeBreakdown {
        GradeBreakdown(
            basicScore: dto.basicScore,
            modifierDelta: dto.modifierDelta,
            finalScore: dto.finalScore,
            criteria: try dto.criteria.map(CriterionBreakdownMapper.toDomain),
            modifiers: dto.modifiers.map(ModifierBreakdownMapper.toDomain)
        )
    }
}

enum CriterionBreakdownMapper {
    static func toDomain(_ dto: CriterionBreakdownDTO) throws -> CriterionBreakdownItem {
        CriterionBreakdownItem(
            criterionId: try dto.criterionId.map(parseUUID),
            title: dto.title,
            type: CriterionType(apiValue: dto.type),
            value: dto.value,
            score: dto.score,
            comment: dto.comment
        )
    }
}

enum ModifierBreakdownMapper {
    static func toDomain(_ dto: ModifierBreakdownDTO) -> ModifierBreakdownItem {
        let type = ModifierType(apiValue: dto.type)

        return ModifierBreakdownItem(
            type: type,
            title: dto.title ?? type.apiValue,
            effect: dto.delta,
            description: dto.description
        )
    }
}
