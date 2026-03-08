//
//  CourseMembershipRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

protocol CourseMembershipRepository: Sendable {
    func joinCourse(_ command: JoinCourseCodeCommand) async throws -> Course
    func leaveCourse(_ command: LeaveCourseCommand) async throws
}

