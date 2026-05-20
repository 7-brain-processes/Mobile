//
//  VoterStatusDTO.swift
//  ProccessesMobile
//
//  Created by Codex on 20.05.2026.
//

import Foundation

struct VoterStatusDTO: Decodable, Equatable, Sendable {
    let user: UserDTO?
    let hasVoted: Bool?
}
