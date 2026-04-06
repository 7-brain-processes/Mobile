//
//  GradingRepositorySpy.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

actor GradingRepositorySpy: GradingRepository {

    // MARK: Result

    private var gradeResult: Result<Solution, Error> =
        .failure(APIError.invalidResponse)

    private var removeGradeResult: Result<Solution, Error> =
        .failure(APIError.invalidResponse)


    // MARK: Recorded calls

    private var recordedGradeCommands: [GradeSolutionCommand] = []
    private var recordedRemoveGradeCommands: [RemoveGradeCommand] = []


    // MARK: Configure

    func setGradeResult(_ result: Result<Solution, Error>) {
        gradeResult = result
    }

    func setRemoveGradeResult(_ result: Result<Solution, Error>) {
        removeGradeResult = result
    }


    // MARK: Inspect

    func getRecordedGradeCommands() -> [GradeSolutionCommand] {
        recordedGradeCommands
    }

    func getRecordedRemoveGradeCommands() -> [RemoveGradeCommand] {
        recordedRemoveGradeCommands
    }


    // MARK: Repository

    func gradeSolution(_ command: GradeSolutionCommand) async throws -> Solution {
        recordedGradeCommands.append(command)
        return try gradeResult.get()
    }

    func removeGrade(_ command: RemoveGradeCommand) async throws -> Solution {
        recordedRemoveGradeCommands.append(command)
        return try removeGradeResult.get()
    }
}
