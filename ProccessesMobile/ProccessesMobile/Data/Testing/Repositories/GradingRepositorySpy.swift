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


    // MARK: Recorded calls

    private var recordedGradeCommands: [GradeSolutionCommand] = []


    // MARK: Configure

    func setGradeResult(_ result: Result<Solution, Error>) {
        gradeResult = result
    }


    // MARK: Inspect

    func getRecordedGradeCommands() -> [GradeSolutionCommand] {
        recordedGradeCommands
    }


    // MARK: Repository

    func gradeSolution(_ command: GradeSolutionCommand) async throws -> Solution {
        recordedGradeCommands.append(command)
        return try gradeResult.get()
    }
}
