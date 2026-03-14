//
//  CourseRepositorySpy.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

actor CourseRepositorySpy: CourseRepository {

    // MARK: Results

    private var getCoursesResult: Result<Page<Course>, Error> =
        .failure(APIError.invalidResponse)

    private var createCourseResult: Result<Course, Error> =
        .failure(APIError.invalidResponse)


    // MARK: Recorded calls

    private var recordedGetCoursesQueries: [GetMyCoursesQuery] = []
    private var recordedCreateCourseCommands: [CreateCourseCommand] = []


    // MARK: Configure results

    func setGetCoursesResult(_ result: Result<Page<Course>, Error>) {
        getCoursesResult = result
    }

    func setCreateCourseResult(_ result: Result<Course, Error>) {
        createCourseResult = result
    }


    // MARK: Inspect

    func getRecordedGetCoursesQueries() -> [GetMyCoursesQuery] {
        recordedGetCoursesQueries
    }

    func getRecordedCreateCourseCommands() -> [CreateCourseCommand] {
        recordedCreateCourseCommands
    }


    // MARK: Repository methods

    func getMyCourses(_ query: GetMyCoursesQuery) async throws -> Page<Course> {
        recordedGetCoursesQueries.append(query)
        return try getCoursesResult.get()
    }

    func createCourse(_ command: CreateCourseCommand) async throws -> Course {
        recordedCreateCourseCommands.append(command)
        return try createCourseResult.get()
    }
}
