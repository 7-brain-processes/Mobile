//
//  CourseRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public protocol CourseRepository: Sendable {
    func getMyCourses(page: Int, size: Int, role: CourseRole?) async throws -> PageCourse
    func createCourse(request: CreateCourseRequest) async throws -> Course
}
