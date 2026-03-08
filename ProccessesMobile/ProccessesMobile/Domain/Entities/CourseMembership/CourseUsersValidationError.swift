//
//  CourseUsersValidationError.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


enum CourseUsersValidationError: Error, Equatable, Sendable {
    case emptyCourseId
    case emptyUserId
    case emptyInviteId
    case invalidMaxUses(minimum: Int)
}