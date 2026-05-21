//
//  DeleteGradingConfigCommand.swift
//  ProccessesMobile
//

import Foundation

struct DeleteGradingConfigCommand: Equatable, Sendable {
    let courseId: UUID
    let postId: UUID
}
