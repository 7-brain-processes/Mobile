//
//  SolutionRepositorySpy.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

actor SolutionRepositorySpy: SolutionRepository {

    private var listResult: Result<Page<ProccessesMobile.Solution>, Error> = .failure(APIError.invalidResponse)
    private var submitResult: Result<ProccessesMobile.Solution, Error> = .failure(APIError.invalidResponse)
    private var getMyResult: Result<ProccessesMobile.Solution, Error> = .failure(APIError.invalidResponse)
    private var getResult: Result<ProccessesMobile.Solution, Error> = .failure(APIError.invalidResponse)
    private var updateResult: Result<ProccessesMobile.Solution, Error> = .failure(APIError.invalidResponse)
    private var deleteResult: Result<Void, Error> = .success(())

    private var recordedListQueries: [ListSolutionsQuery] = []
    private var recordedSubmitCommands: [SubmitSolutionCommand] = []
    private var recordedGetMyQueries: [GetMySolutionQuery] = []
    private var recordedGetCommands: [SolutionOfPost] = []
    private var recordedUpdateCommands: [UpdateSolutionCommand] = []
    private var recordedDeleteCommands: [SolutionOfPost] = []

    func setListResult(_ result: Result<Page<ProccessesMobile.Solution>, Error>) {
        listResult = result
    }

    func setSubmitResult(_ result: Result<ProccessesMobile.Solution, Error>) {
        submitResult = result
    }

    func setGetMyResult(_ result: Result<ProccessesMobile.Solution, Error>) {
        getMyResult = result
    }

    func setGetResult(_ result: Result<ProccessesMobile.Solution, Error>) {
        getResult = result
    }

    func setUpdateResult(_ result: Result<ProccessesMobile.Solution, Error>) {
        updateResult = result
    }

    func setDeleteResult(_ result: Result<Void, Error>) {
        deleteResult = result
    }

    func getRecordedListQueries() -> [ListSolutionsQuery] {
        recordedListQueries
    }

    func getRecordedSubmitCommands() -> [SubmitSolutionCommand] {
        recordedSubmitCommands
    }

    func getRecordedGetMyQueries() -> [GetMySolutionQuery] {
        recordedGetMyQueries
    }

    func getRecordedGetCommands() -> [SolutionOfPost] {
        recordedGetCommands
    }

    func getRecordedUpdateCommands() -> [UpdateSolutionCommand] {
        recordedUpdateCommands
    }

    func getRecordedDeleteCommands() -> [SolutionOfPost] {
        recordedDeleteCommands
    }

    func listSolutions(_ query: ListSolutionsQuery) async throws -> Page<ProccessesMobile.Solution> {
        recordedListQueries.append(query)
        return try listResult.get()
    }

    func submitSolution(_ command: SubmitSolutionCommand) async throws -> ProccessesMobile.Solution {
        recordedSubmitCommands.append(command)
        return try submitResult.get()
    }

    func getMySolution(_ command: GetMySolutionQuery) async throws -> ProccessesMobile.Solution {
        recordedGetMyQueries.append(command)
        return try getMyResult.get()
    }

    func getSolution(_ command: SolutionOfPost) async throws -> ProccessesMobile.Solution {
        recordedGetCommands.append(command)
        return try getResult.get()
    }

    func updateSolution(_ command: UpdateSolutionCommand) async throws -> ProccessesMobile.Solution {
        recordedUpdateCommands.append(command)
        return try updateResult.get()
    }

    func deleteSolution(_ command: SolutionOfPost) async throws {
        recordedDeleteCommands.append(command)
        try deleteResult.get()
    }
}
