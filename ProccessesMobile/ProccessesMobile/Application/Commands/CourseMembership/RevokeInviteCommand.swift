//
//  RevokeInviteCommand.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//

import Foundation

struct RevokeInviteCommand: Equatable, Sendable {
    let courseId: UUID
    let inviteId: UUID
}
