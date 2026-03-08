//
//  SolutionRepositorySpy.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

actor SolutionRepositorySpy: SolutionRepository {

    private var listResult: Result<Page<Solution>, Error> = .failure(APIError.invalidResponse)
    private var submitResult: Result<Solution, Error> = .failure(APIError.invalidResponse)
    private var getMyResult: Result<Solution, Error> = .failure(APIError.invalidResponse)
    private var getResult: Result<Solution, Error> = .failure(APIError.invalidResponse)
    private var updateResult: Result<Solution, Error> = .failure(APIError.invalidResponse)
    private var deleteResult: Result<Void, Error> = .success(())

    func setListResult(_ res: Result<Page<Solution>, Error>) { listResult = res }
    func setSubmitResult(_ res: Result<Solution, Error>) { submitResult = res }
    func setGetMyResult(_ res: Result<Solution, Error>) { getMyResult = res }
    func setGetResult(_ res: Result<Solution, Error>) { getResult = res }
    func setUpdateResult(_ res: Result<Solution, Error>) { updateResult = res }
    func setDeleteResult(_ res: Result<Void, Error>) { deleteResult = res }

    private var recordedListQueries: [ListSolutionsQuery] = []
    private var recordedSubmitCommands: [SubmitSolutionCommand] = []
    private var recordedGetMyArgs: [GetMySolutionQuery] = []
    private var recordedGetCommands: [SolutionOfPost] = []
    private var recordedUpdateCommands: [UpdateSolutionCommand] = []
    private var recordedDeleteCommands: [SolutionOfPost] = []

    func getRecordedListQueries() -> [ListSolutionsQuery] { recordedListQueries }
    func getRecordedSubmitCommands() -> [SubmitSolutionCommand] { recordedSubmitCommands }
    func getRecordedGetMyArgs() -> [GetMySolutionQuery] { recordedGetMyArgs }
    func getRecordedGetCommands() -> [SolutionOfPost] { recordedGetCommands }
    func getRecordedUpdateCommands() -> [UpdateSolutionCommand] { recordedUpdateCommands }
    func getRecordedDeleteCommands() -> [SolutionOfPost] { recordedDeleteCommands }

    func listSolutions(_ query: ListSolutionsQuery) async throws -> Page<Solution> {
        recordedListQueries.append(query)
        return try listResult.get()
    }

    func submitSolution(_ command: SubmitSolutionCommand) async throws -> Solution {
        recordedSubmitCommands.append(command)
        return try submitResult.get()
    }

    func getMySolution(_ command: GetMySolutionQuery) async throws -> Solution {
        recordedGetMyArgs.append(command)
        return try getMyResult.get()
    }

    func getSolution(_ command: SolutionOfPost) async throws -> Solution {
        recordedGetCommands.append(command)
        return try getResult.get()
    }

    func updateSolution(_ command: UpdateSolutionCommand) async throws -> Solution {
        recordedUpdateCommands.append(command)
        return try updateResult.get()
    }

    func deleteSolution(_ command: SolutionOfPost) async throws {
        recordedDeleteCommands.append(command)
        try deleteResult.get()
    }
}
