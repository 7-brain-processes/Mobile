//
//  CourseRepositorySpy.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

actor CourseRepositorySpy: CourseRepository {

    var getCoursesResult: Result<PageCourse, Error> = .failure(APIError.invalidResponse)
    var createCourseResult: Result<Course, Error> = .failure(APIError.invalidResponse)
    
    struct GetCoursesArgs: Equatable { let page: Int; let size: Int; let role: CourseRole? }
    var recordedGetCoursesArgs: [GetCoursesArgs] = []
    
    struct CreateCourseArgs: Equatable { let request: CreateCourseRequest }
    var recordedCreateCourseArgs: [CreateCourseArgs] = []
    
    func setGetCoursesResult(_ result: Result<PageCourse, Error>) { self.getCoursesResult = result }
    func setCreateCourseResult(_ result: Result<Course, Error>) { self.createCourseResult = result }
    
    func getMyCourses(page: Int, size: Int, role: CourseRole?) async throws -> PageCourse {
        recordedGetCoursesArgs.append(GetCoursesArgs(page: page, size: size, role: role))
        return try getCoursesResult.get()
    }
    
    func createCourse(request: CreateCourseRequest) async throws -> Course {
        recordedCreateCourseArgs.append(CreateCourseArgs(request: request))
        return try createCourseResult.get()
    }
}
