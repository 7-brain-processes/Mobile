//
//  DeleteSolutionCommentCommand.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//

import Foundation

struct DeleteSolutionCommentCommand: Equatable, Sendable {
    let courseId: UUID
    let postId: UUID
    let solutionId: UUID
    let commentId: UUID
}
