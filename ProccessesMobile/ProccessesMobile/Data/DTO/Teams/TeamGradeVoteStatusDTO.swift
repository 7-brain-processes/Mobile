//
//  TeamGradeVoteStatusDTO.swift
//  ProccessesMobile
//
//  Created by Codex on 20.05.2026.
//

import Foundation

struct TeamGradeVoteStatusDTO: Decodable, Equatable, Sendable {
    let teamId: String?
    let teamGrade: Int?
    let finalized: Bool?
    let voters: [VoterStatusDTO]?
    let myVote: [StudentDistributedGradeDTO]?
    let finalDistribution: [StudentDistributedGradeDTO]?
}
