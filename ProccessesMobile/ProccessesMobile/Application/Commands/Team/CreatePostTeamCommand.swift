//
//  CreatePostTeamCommand.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 20.05.2026.
//

import Foundation

struct CreatePostTeamCommand: Equatable, Sendable {
    let courseId: UUID
    let postId: UUID
    let name: String
    let maxSize: Int?
    let selfEnrollmentEnabled: Bool
}
