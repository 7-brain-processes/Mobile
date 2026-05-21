//
//  GetGradingConfigQuery.swift
//  ProccessesMobile
//

import Foundation

struct GetGradingConfigQuery: Equatable, Sendable {
    let courseId: UUID
    let postId: UUID
}
