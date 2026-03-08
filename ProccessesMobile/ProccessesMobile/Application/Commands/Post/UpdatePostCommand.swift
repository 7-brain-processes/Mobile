//
//  UpdatePostCommand.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct UpdatePostCommand: Equatable, Sendable {
    let courseId: UUID
    let postId: UUID
    let title: String?
    let content: String?
    let deadline: Date?
}

extension UpdatePostCommand {
    func toDTO() -> UpdatePostRequestDTO {
        UpdatePostRequestDTO(
            title: title,
            content: content,
            deadline: deadline.map(formatDate)
        )
    }
}
