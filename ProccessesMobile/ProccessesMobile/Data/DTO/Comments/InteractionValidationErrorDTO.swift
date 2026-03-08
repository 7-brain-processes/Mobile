//
//  InteractionValidationError.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

enum InteractionValidationErrorDTO: Error, Equatable, Sendable {
    case emptyId(String)
    case invalidCommentLength(min: Int, max: Int)
    case invalidGrade(min: Int, max: Int)
}
