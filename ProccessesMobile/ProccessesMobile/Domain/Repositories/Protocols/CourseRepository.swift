//
//  CourseRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


protocol CourseRepository: Sendable {
    func getMyCourses(_ query: GetMyCoursesQuery) async throws -> Page<Course>
    func createCourse(_ command: CreateCourseCommand) async throws -> Course
}
