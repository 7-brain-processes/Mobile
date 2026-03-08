//
//  InteractionValidationError.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


enum InteractionValidationError: Error, Equatable, Sendable {
    case emptyId(String)
    case invalidCommentLength(min: Int, max: Int)
    case invalidGrade(min: Int, max: Int)
}
