//
//  UpdateCriteriaGradesUseCase.swift
//  ProccessesMobile
//

protocol UpdateCriteriaGradesUseCase: Sendable {
    func execute(_ command: UpdateCriteriaGradesCommand) async throws -> AssessmentResult
}

struct DefaultUpdateCriteriaGradesUseCase: UpdateCriteriaGradesUseCase {
    private let repository: AssessmentRepository

    init(repository: AssessmentRepository) {
        self.repository = repository
    }

    func execute(_ command: UpdateCriteriaGradesCommand) async throws -> AssessmentResult {
        try validate(command.grades, using: command.config)
        return try await repository.updateCriteriaGrades(command)
    }

    private func validate(
        _ grades: [CriterionGrade],
        using config: AssessmentConfig?
    ) throws {
        guard let config else { return }

        let criteriaById = Dictionary(
            uniqueKeysWithValues: config.criteria.compactMap { criterion in
                criterion.id.map { ($0, criterion) }
            }
        )

        for grade in grades {
            guard let criterion = criteriaById[grade.criterionId] else {
                continue
            }

            switch criterion.type {
            case .boolean:
                guard grade.value == 0 || grade.value == 1 else {
                    throw AssessmentValidationError.invalidBooleanValue
                }
            case .percent:
                guard (0...100).contains(grade.value) else {
                    throw AssessmentValidationError.percentOutOfRange(min: 0, max: 100)
                }
            case .points:
                guard grade.value <= criterion.maxPoints else {
                    throw AssessmentValidationError.pointsAboveMaximum(maxPoints: criterion.maxPoints)
                }
            case .unknown:
                continue
            }
        }
    }
}
