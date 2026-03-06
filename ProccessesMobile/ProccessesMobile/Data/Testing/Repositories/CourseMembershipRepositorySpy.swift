//
//  CourseMembershipRepositorySpy.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

actor CourseMembershipRepositorySpy: CourseMembershipRepository {
    
    private var joinResult: Result<Course, Error> = .failure(APIError.invalidResponse)
    private var leaveResult: Result<Void, Error> = .success(())
    
    private var recordedJoinArgs: [String] = []
    private var recordedLeaveArgs: [String] = []
    
    func setJoinResult(_ result: Result<Course, Error>) { self.joinResult = result }
    func setLeaveResult(_ result: Result<Void, Error>) { self.leaveResult = result }
    
    func getRecordedJoinArgs() -> [String] { return recordedJoinArgs }
    func getRecordedLeaveArgs() -> [String] { return recordedLeaveArgs }
    
    func joinCourse(code: String) async throws -> Course {
        recordedJoinArgs.append(code)
        return try joinResult.get()
    }
    
    func leaveCourse(courseId: String) async throws {
        recordedLeaveArgs.append(courseId)
        return try leaveResult.get()
    }
}
