//
//  UpsertGradingConfigCommand.swift
//  ProccessesMobile
//

import Foundation

struct UpsertGradingConfigCommand: Equatable, Sendable {
    let courseId: UUID
    let postId: UUID
    let config: AssessmentConfig
}
