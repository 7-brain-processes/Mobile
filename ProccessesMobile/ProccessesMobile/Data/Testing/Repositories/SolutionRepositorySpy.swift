//
//  SolutionRepositorySpy.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


actor SolutionRepositorySpy: SolutionRepository {
    private var listResult: Result<PageSolution, Error> = .failure(APIError.invalidResponse)
    private var submitResult: Result<Solution, Error> = .failure(APIError.invalidResponse)
    private var getMyResult: Result<Solution, Error> = .failure(APIError.invalidResponse)
    private var getResult: Result<Solution, Error> = .failure(APIError.invalidResponse)
    private var updateResult: Result<Solution, Error> = .failure(APIError.invalidResponse)
    private var deleteResult: Result<Void, Error> = .success(())
    
    func setListResult(_ res: Result<PageSolution, Error>) { listResult = res }
    func setSubmitResult(_ res: Result<Solution, Error>) { submitResult = res }
    func setGetMyResult(_ res: Result<Solution, Error>) { getMyResult = res }
    func setGetResult(_ res: Result<Solution, Error>) { getResult = res }
    func setUpdateResult(_ res: Result<Solution, Error>) { updateResult = res }
    func setDeleteResult(_ res: Result<Void, Error>) { deleteResult = res }
    
    struct ListArgs: Equatable { let courseId: String; let postId: String; let page: Int; let size: Int; let status: SolutionStatus? }
    struct SubmitArgs: Equatable { let courseId: String; let postId: String; let request: CreateSolutionRequest }
    struct GetMyArgs: Equatable { let courseId: String; let postId: String }
    struct GetArgs: Equatable { let courseId: String; let postId: String; let solutionId: String }
    struct UpdateArgs: Equatable { let courseId: String; let postId: String; let solutionId: String; let request: CreateSolutionRequest }
    
    private var recordedListArgs: [ListArgs] = []
    private var recordedSubmitArgs: [SubmitArgs] = []
    private var recordedGetMyArgs: [GetMyArgs] = []
    private var recordedGetArgs: [GetArgs] = []
    private var recordedUpdateArgs: [UpdateArgs] = []
    private var recordedDeleteArgs: [GetArgs] = []
    
    func getRecordedListArgs() -> [ListArgs] { return recordedListArgs }
    func getRecordedSubmitArgs() -> [SubmitArgs] { return recordedSubmitArgs }
    func getRecordedGetMyArgs() -> [GetMyArgs] { return recordedGetMyArgs }
    func getRecordedGetArgs() -> [GetArgs] { return recordedGetArgs }
    func getRecordedUpdateArgs() -> [UpdateArgs] { return recordedUpdateArgs }
    func getRecordedDeleteArgs() -> [GetArgs] { return recordedDeleteArgs }
    
    func listSolutions(courseId: String, postId: String, page: Int, size: Int, status: SolutionStatus?) async throws -> PageSolution {
        recordedListArgs.append(ListArgs(courseId: courseId, postId: postId, page: page, size: size, status: status))
        return try listResult.get()
    }
    func submitSolution(courseId: String, postId: String, request: CreateSolutionRequest) async throws -> Solution {
        recordedSubmitArgs.append(SubmitArgs(courseId: courseId, postId: postId, request: request))
        return try submitResult.get()
    }
    func getMySolution(courseId: String, postId: String) async throws -> Solution {
        recordedGetMyArgs.append(GetMyArgs(courseId: courseId, postId: postId))
        return try getMyResult.get()
    }
    func getSolution(courseId: String, postId: String, solutionId: String) async throws -> Solution {
        recordedGetArgs.append(GetArgs(courseId: courseId, postId: postId, solutionId: solutionId))
        return try getResult.get()
    }
    func updateSolution(courseId: String, postId: String, solutionId: String, request: CreateSolutionRequest) async throws -> Solution {
        recordedUpdateArgs.append(UpdateArgs(courseId: courseId, postId: postId, solutionId: solutionId, request: request))
        return try updateResult.get()
    }
    func deleteSolution(courseId: String, postId: String, solutionId: String) async throws {
        recordedDeleteArgs.append(GetArgs(courseId: courseId, postId: postId, solutionId: solutionId))
        return try deleteResult.get()
    }
}
