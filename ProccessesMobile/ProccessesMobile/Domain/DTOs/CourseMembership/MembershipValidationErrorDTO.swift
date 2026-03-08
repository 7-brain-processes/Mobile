//
//  MembershipValidationError.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

enum MembershipValidationErrorDTO: Error, Equatable, Sendable {
    case emptyCourseId
    case emptyInviteCode
}
