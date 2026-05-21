//
//  GetGradeDecompositionUseCase.swift
//  ProccessesMobile
//

protocol GetGradeDecompositionUseCase: Sendable {
    func execute(_ query: GetGradeDecompositionQuery) async throws -> GradeBreakdown
}

struct DefaultGetGradeDecompositionUseCase: GetGradeDecompositionUseCase {
    private let repository: AssessmentRepository

    init(repository: AssessmentRepository) {
        self.repository = repository
    }

    func execute(_ query: GetGradeDecompositionQuery) async throws -> GradeBreakdown {
        try await repository.getMyGradeDecomposition(query)
    }
}
