//
//  CreatePostCommentCommand.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//

import Foundation

struct CreatePostCommentCommand: Equatable, Sendable {
    let courseId: UUID
    let postId: UUID
    let text: String
}
