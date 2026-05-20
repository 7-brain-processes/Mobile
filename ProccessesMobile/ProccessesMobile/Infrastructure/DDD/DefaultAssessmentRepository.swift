//
//  DefaultAssessmentRepository.swift
//  ProccessesMobile
//

import Foundation

struct DefaultAssessmentRepository: AssessmentRepository, Sendable {
    private let apiClient: APIClient
    private let decoder: JSONDecoder

    init(
        apiClient: APIClient,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.apiClient = apiClient
        self.decoder = decoder
    }

    func getConfig(_ query: GetGradingConfigQuery) async throws -> AssessmentConfig {
        let endpoint = AssessmentEndpoint.getGradingConfig(
            courseId: query.courseId.uuidString,
            postId: query.postId.uuidString
        )

        let dto: GradingConfigResponseDTO = try await decode(
            endpoint,
            successCodes: [200]
        )

        return try AssessmentConfigMapper.toDomain(dto)
    }

    func upsertConfig(_ command: UpsertGradingConfigCommand) async throws -> AssessmentConfig {
        let endpoint = AssessmentEndpoint.upsertGradingConfig(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            request: AssessmentConfigMapper.toDTO(command.config)
        )

        let dto: GradingConfigResponseDTO = try await decode(
            endpoint,
            successCodes: [200, 201]
        )

        return try AssessmentConfigMapper.toDomain(dto)
    }

    func deleteConfig(_ command: DeleteGradingConfigCommand) async throws {
        let endpoint = AssessmentEndpoint.deleteGradingConfig(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString
        )

        let (_, response) = try await apiClient.send(endpoint)
        try ResponseValidator.validate(response, successCodes: [200, 204])
    }

    func getCriteriaGrades(_ query: GetCriteriaGradesQuery) async throws -> AssessmentResult {
        let endpoint = AssessmentEndpoint.getCriteriaGrades(
            courseId: query.courseId.uuidString,
            postId: query.postId.uuidString,
            solutionId: query.solutionId.uuidString
        )

        let dto: CriteriaGradeResponseDTO = try await decode(
            endpoint,
            successCodes: [200]
        )

        return try AssessmentResultMapper.toDomain(dto)
    }

    func updateCriteriaGrades(_ command: UpdateCriteriaGradesCommand) async throws -> AssessmentResult {
        let endpoint = AssessmentEndpoint.updateCriteriaGrades(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            solutionId: command.solutionId.uuidString,
            request: AssessmentResultMapper.toDTO(command.grades)
        )

        let dto: CriteriaGradeResponseDTO = try await decode(
            endpoint,
            successCodes: [200]
        )

        return try AssessmentResultMapper.toDomain(dto)
    }

    func publishCriteriaGrades(_ command: PublishCriteriaGradesCommand) async throws -> AssessmentResult {
        let endpoint = AssessmentEndpoint.publishCriteriaGrades(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            solutionId: command.solutionId.uuidString
        )

        let dto: CriteriaGradeResponseDTO = try await decode(
            endpoint,
            successCodes: [200]
        )

        return try AssessmentResultMapper.toDomain(dto)
    }

    func getMyGradeDecomposition(_ query: GetGradeDecompositionQuery) async throws -> GradeBreakdown {
        let endpoint = AssessmentEndpoint.getMyGradeDecomposition(
            courseId: query.courseId.uuidString,
            postId: query.postId.uuidString
        )

        let dto: GradeDecompositionResponseDTO = try await decode(
            endpoint,
            successCodes: [200]
        )

        return try GradeBreakdownMapper.toDomain(dto)
    }

    private func decode<T: Decodable>(
        _ endpoint: Endpoint,
        successCodes: Set<Int>
    ) async throws -> T {
        let (data, response) = try await apiClient.send(endpoint)
        try ResponseValidator.validate(response, successCodes: successCodes)
        return try decoder.decode(T.self, from: data)
    }
}
