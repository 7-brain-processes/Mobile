//
//  TeamGradeVoteStatus.swift
//  ProccessesMobile
//
//  Created by Codex on 20.05.2026.
//

import Foundation

struct TeamGradeVoteStatus: Equatable, Sendable {
    let teamId: UUID
    let teamGrade: Int?
    let finalized: Bool
    let voters: [VoterStatus]
    let myVote: [StudentDistributedGrade]
    let finalDistribution: [StudentDistributedGrade]

    var state: VotingState {
        if finalized {
            return .completed
        }

        if voters.contains(where: \.hasVoted) {
            return .inProgress
        }

        return .notStarted
    }

    var canSubmitVote: Bool {
        !finalized && myVote.isEmpty && teamGrade != nil
    }

    var votedCount: Int {
        voters.filter(\.hasVoted).count
    }

    enum VotingState: Equatable, Sendable {
        case notStarted
        case inProgress
        case completed

        var title: String {
            switch self {
            case .notStarted:
                return "Not started"
            case .inProgress:
                return "In progress"
            case .completed:
                return "Completed"
            }
        }
    }
}
