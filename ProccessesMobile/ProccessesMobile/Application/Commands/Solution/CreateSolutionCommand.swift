//
//  CreateSolutionCommand.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct SubmitSolutionCommand: Equatable, Sendable {
    let courseId: UUID
    let postId: UUID
    let text: String?
}

extension SubmitSolutionCommand {
    func toDTO() -> CreateSolutionRequestDTO {
        CreateSolutionRequestDTO(text: text)
    }
}
