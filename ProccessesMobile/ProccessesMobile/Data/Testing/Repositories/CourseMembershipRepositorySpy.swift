//
//  CourseMembershipRepositorySpy.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

actor CourseMembershipRepositorySpy: CourseMembershipRepository {

    // MARK: Results

    private var joinResult: Result<Course, Error> =
        .failure(APIError.invalidResponse)

    private var leaveResult: Result<Void, Error> =
        .success(())


    // MARK: Recorded calls

    private var recordedJoinCommands: [JoinCourseCodeCommand] = []
    private var recordedLeaveCommands: [LeaveCourseCommand] = []


    // MARK: Configure results

    func setJoinResult(_ result: Result<Course, Error>) {
        joinResult = result
    }

    func setLeaveResult(_ result: Result<Void, Error>) {
        leaveResult = result
    }


    // MARK: Inspect calls

    func getRecordedJoinCommands() -> [JoinCourseCodeCommand] {
        recordedJoinCommands
    }

    func getRecordedLeaveCommands() -> [LeaveCourseCommand] {
        recordedLeaveCommands
    }


    // MARK: Repository methods

    func joinCourse(_ command: JoinCourseCodeCommand) async throws -> Course {
        recordedJoinCommands.append(command)
        return try joinResult.get()
    }

    func leaveCourse(_ command: LeaveCourseCommand) async throws {
        recordedLeaveCommands.append(command)
        try leaveResult.get()
    }
}
