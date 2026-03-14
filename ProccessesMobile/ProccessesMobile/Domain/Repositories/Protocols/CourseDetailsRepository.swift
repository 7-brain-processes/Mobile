//
//  CourseDetailsRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

typealias GetCourseQuery = CourseQuery
typealias DeleteCourseQuery = CourseQuery

protocol CourseDetailsRepository: Sendable {
    func getCourse(_ query: GetCourseQuery) async throws -> Course
    func updateCourse(_ command: UpdateCourseCommand) async throws -> Course
    func deleteCourse(_ query: DeleteCourseQuery) async throws
}

