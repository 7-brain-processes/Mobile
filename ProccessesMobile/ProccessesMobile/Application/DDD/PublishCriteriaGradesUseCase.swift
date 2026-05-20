//
//  PublishCriteriaGradesUseCase.swift
//  ProccessesMobile
//

protocol PublishCriteriaGradesUseCase: Sendable {
    func execute(_ command: PublishCriteriaGradesCommand) async throws -> AssessmentResult
}

struct DefaultPublishCriteriaGradesUseCase: PublishCriteriaGradesUseCase {
    private let repository: AssessmentRepository

    init(repository: AssessmentRepository) {
        self.repository = repository
    }

    func execute(_ command: PublishCriteriaGradesCommand) async throws -> AssessmentResult {
        try await repository.publishCriteriaGrades(command)
    }
}
