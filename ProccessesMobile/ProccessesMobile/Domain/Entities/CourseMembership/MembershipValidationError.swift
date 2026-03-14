//
//  MembershipValidationError.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

enum MembershipValidationError: Error, Equatable, Sendable {
    case emptyCourseId
    case emptyInviteCode
}
