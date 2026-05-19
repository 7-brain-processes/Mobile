//
//  AssessmentRepository.swift
//  ProccessesMobile
//

protocol AssessmentRepository: Sendable {
    func getConfig(_ query: GetGradingConfigQuery) async throws -> AssessmentConfig
    func upsertConfig(_ command: UpsertGradingConfigCommand) async throws -> AssessmentConfig
    func deleteConfig(_ command: DeleteGradingConfigCommand) async throws
    func getCriteriaGrades(_ query: GetCriteriaGradesQuery) async throws -> AssessmentResult
    func updateCriteriaGrades(_ command: UpdateCriteriaGradesCommand) async throws -> AssessmentResult
    func publishCriteriaGrades(_ command: PublishCriteriaGradesCommand) async throws -> AssessmentResult
    func getMyGradeDecomposition(_ query: GetGradeDecompositionQuery) async throws -> GradeBreakdown
}
