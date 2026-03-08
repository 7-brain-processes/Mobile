//
//  CourseDetailsRepositorySpy.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

actor CourseDetailsRepositorySpy: CourseDetailsRepository {

    // MARK: Results

    private var getResult: Result<Course, Error> =
        .failure(APIError.invalidResponse)

    private var updateResult: Result<Course, Error> =
        .failure(APIError.invalidResponse)

    private var deleteResult: Result<Void, Error> =
        .success(())


    // MARK: Recorded calls

    private var recordedGetQueries: [GetCourseQuery] = []
    private var recordedUpdateCommands: [UpdateCourseCommand] = []
    private var recordedDeleteQueries: [DeleteCourseQuery] = []


    // MARK: Configure results

    func setGetResult(_ result: Result<Course, Error>) {
        getResult = result
    }

    func setUpdateResult(_ result: Result<Course, Error>) {
        updateResult = result
    }

    func setDeleteResult(_ result: Result<Void, Error>) {
        deleteResult = result
    }


    // MARK: Inspect calls

    func getRecordedGetQueries() -> [GetCourseQuery] {
        recordedGetQueries
    }

    func getRecordedUpdateCommands() -> [UpdateCourseCommand] {
        recordedUpdateCommands
    }

    func getRecordedDeleteQueries() -> [DeleteCourseQuery] {
        recordedDeleteQueries
    }


    // MARK: Repository methods

    func getCourse(_ query: GetCourseQuery) async throws -> Course {
        recordedGetQueries.append(query)
        return try getResult.get()
    }

    func updateCourse(_ command: UpdateCourseCommand) async throws -> Course {
        recordedUpdateCommands.append(command)
        return try updateResult.get()
    }

    func deleteCourse(_ query: DeleteCourseQuery) async throws {
        recordedDeleteQueries.append(query)
        try deleteResult.get()
    }
}
