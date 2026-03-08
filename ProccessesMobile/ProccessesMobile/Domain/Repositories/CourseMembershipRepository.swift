//
//  CourseMembershipRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


protocol CourseMembershipRepository: Sendable {
    func joinCourse(code: String) async throws -> Course
    func leaveCourse(courseId: String) async throws
}
