//
//  CourseMembersRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public protocol CourseMembersRepository: Sendable {
    func listMembers(courseId: String, page: Int, size: Int, role: CourseRole?) async throws -> PageMember
    func removeMember(courseId: String, userId: String) async throws
}