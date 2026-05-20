//
//  AssessmentResultMapper.swift
//  ProccessesMobile
//

import Foundation

enum CriterionGradeMapper {
    static func toDomain(_ dto: CriterionGradeEntryDTO) throws -> CriterionGrade {
        CriterionGrade(
            criterionId: try parseUUID(dto.criterionId),
            value: dto.value,
            comment: dto.comment
        )
    }

    static func toDTO(_ grade: CriterionGrade) -> CriterionGradeEntryDTO {
        CriterionGradeEntryDTO(
            criterionId: grade.criterionId.uuidString,
            value: grade.value,
            comment: grade.comment
        )
    }
}

enum ModifierEffectMapper {
    static func toDomain(_ dto: ModifierEffectDTO) -> ModifierEffect {
        ModifierEffect(
            type: ModifierType(apiValue: dto.type),
            value: dto.value,
            description: dto.description
        )
    }
}

enum AssessmentResultMapper {
    static func toDomain(_ dto: CriteriaGradeResponseDTO) throws -> AssessmentResult {
        AssessmentResult(
            solutionId: try parseUUID(dto.solutionId),
            criteriaGrades: try dto.criteriaGrades.map(CriterionGradeMapper.toDomain),
            modifierEffects: dto.modifierEffects.map(ModifierEffectMapper.toDomain),
            basicScore: dto.basicScore,
            finalScore: dto.finalScore,
            published: dto.published
        )
    }

    static func toDTO(_ grades: [CriterionGrade]) -> CriteriaGradeRequestDTO {
        CriteriaGradeRequestDTO(
            criteria: grades.map(CriterionGradeMapper.toDTO)
        )
    }
}
