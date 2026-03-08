//
//  UpdatePostCommentCommand.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//

import Foundation

struct UpdatePostCommentCommand: Equatable, Sendable {
    let courseId: UUID
    let postId: UUID
    let commentId: UUID
    let text: String
}

extension UpdatePostCommentCommand {
    func toDTO() -> CreateCommentRequestDTO {
        CreateCommentRequestDTO(
            text: text
        )
    }
}
