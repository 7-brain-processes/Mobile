//
//  CourseDetailsRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public protocol CourseDetailsRepository: Sendable {
    func getCourse(courseId: String) async throws -> Course
    func updateCourse(courseId: String, request: UpdateCourseRequest) async throws -> Course
    func deleteCourse(courseId: String) async throws
}
