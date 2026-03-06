//
//  MembershipValidationError.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public enum MembershipValidationError: Error, Equatable, Sendable {
    case emptyCourseId
    case emptyInviteCode
}
