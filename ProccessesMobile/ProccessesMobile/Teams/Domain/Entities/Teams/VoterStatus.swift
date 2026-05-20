//
//  VoterStatus.swift
//  ProccessesMobile
//
//  Created by Codex on 20.05.2026.
//

import Foundation

struct VoterStatus: Equatable, Sendable {
    let user: User
    let hasVoted: Bool
}
