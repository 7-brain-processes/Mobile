//
//  CourseDetailsRepositorySpy.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

actor CourseDetailsRepositorySpy: CourseDetailsRepository {
    private var getResult: Result<Course, Error> = .failure(APIError.invalidResponse)
    private var updateResult: Result<Course, Error> = .failure(APIError.invalidResponse)
    private var deleteResult: Result<Void, Error> = .success(())
    
    private var recordedGetArgs: [String] = []
    struct UpdateArgs: Equatable { let id: String; let req: UpdateCourseRequest }
    private var recordedUpdateArgs: [UpdateArgs] = []
    private var recordedDeleteArgs: [String] = []
    
    func setGetResult(_ res: Result<Course, Error>) { getResult = res }
    func setUpdateResult(_ res: Result<Course, Error>) { updateResult = res }
    func setDeleteResult(_ res: Result<Void, Error>) { deleteResult = res }
    
    func getRecordedGetArgs() -> [String] { return recordedGetArgs }
    func getRecordedUpdateArgs() -> [UpdateArgs] { return recordedUpdateArgs }
    func getRecordedDeleteArgs() -> [String] { return recordedDeleteArgs }
    
    func getCourse(courseId: String) async throws -> Course {
        recordedGetArgs.append(courseId)
        return try getResult.get()
    }
    
    func updateCourse(courseId: String, request: UpdateCourseRequest) async throws -> Course {
        recordedUpdateArgs.append(UpdateArgs(id: courseId, req: request))
        return try updateResult.get()
    }
    
    func deleteCourse(courseId: String) async throws {
        recordedDeleteArgs.append(courseId)
        return try deleteResult.get()
    }
}
