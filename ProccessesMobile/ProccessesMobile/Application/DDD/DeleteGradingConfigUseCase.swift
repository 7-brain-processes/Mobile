//
//  DeleteGradingConfigUseCase.swift
//  ProccessesMobile
//

protocol DeleteGradingConfigUseCase: Sendable {
    func execute(_ command: DeleteGradingConfigCommand) async throws
}

struct DefaultDeleteGradingConfigUseCase: DeleteGradingConfigUseCase {
    private let repository: AssessmentRepository

    init(repository: AssessmentRepository) {
        self.repository = repository
    }

    func execute(_ command: DeleteGradingConfigCommand) async throws {
        try await repository.deleteConfig(command)
    }
}
