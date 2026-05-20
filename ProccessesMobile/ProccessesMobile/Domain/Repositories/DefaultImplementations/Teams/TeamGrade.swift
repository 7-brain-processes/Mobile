//
//  TeamGrade.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 20.05.2026.
//

import Foundation

struct TeamGrade: Equatable, Sendable {
    let id: UUID?
    let postId: UUID
    let teamId: UUID
    let grade: Int?
    let comment: String?
    let distributionMode: String?
    let updatedAt: Date?
}
