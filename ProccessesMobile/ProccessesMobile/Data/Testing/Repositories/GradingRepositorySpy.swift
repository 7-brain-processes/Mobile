//
//  GradingRepositorySpy.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


actor GradingRepositorySpy: GradingRepository {
    private var gradeResult: Result<Solution, Error> = .failure(APIError.invalidResponse)
    func setGradeResult(_ result: Result<Solution, Error>) { gradeResult = result }
    
    struct GradeArgs: Equatable { let courseId: String; let postId: String; let solutionId: String; let request: GradeRequest }
    private var recordedGradeArgs: [GradeArgs] = []
    func getRecordedGradeArgs() -> [GradeArgs] { return recordedGradeArgs }
    
    func gradeSolution(courseId: String, postId: String, solutionId: String, request: GradeRequest) async throws -> Solution {
        recordedGradeArgs.append(GradeArgs(courseId: courseId, postId: postId, solutionId: solutionId, request: request))
        return try gradeResult.get()
    }
}
