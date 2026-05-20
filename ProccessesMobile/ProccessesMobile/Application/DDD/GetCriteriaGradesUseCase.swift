//
//  GetCriteriaGradesUseCase.swift
//  ProccessesMobile
//

protocol GetCriteriaGradesUseCase: Sendable {
    func execute(_ query: GetCriteriaGradesQuery) async throws -> AssessmentResult
}

struct DefaultGetCriteriaGradesUseCase: GetCriteriaGradesUseCase {
    private let repository: AssessmentRepository

    init(repository: AssessmentRepository) {
        self.repository = repository
    }

    func execute(_ query: GetCriteriaGradesQuery) async throws -> AssessmentResult {
        try await repository.getCriteriaGrades(query)
    }
}
