//
//  GetGradingConfigUseCase.swift
//  ProccessesMobile
//

protocol GetGradingConfigUseCase: Sendable {
    func execute(_ query: GetGradingConfigQuery) async throws -> AssessmentConfig
}

struct DefaultGetGradingConfigUseCase: GetGradingConfigUseCase {
    private let repository: AssessmentRepository

    init(repository: AssessmentRepository) {
        self.repository = repository
    }

    func execute(_ query: GetGradingConfigQuery) async throws -> AssessmentConfig {
        try await repository.getConfig(query)
    }
}
