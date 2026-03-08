//
//  CourseUsersValidationError.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

enum CourseUsersValidationErrorDTO: Error, Equatable, Sendable {
    case emptyCourseId
    case emptyUserId
    case emptyInviteId
    case invalidMaxUses(minimum: Int)
}
