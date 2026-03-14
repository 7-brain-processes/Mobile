//
//  InteractionValidationError.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

enum InteractionValidationError: Error, Equatable, Sendable {
    case emptyId(UUID)
    case invalidCommentLength(min: Int, max: Int)
    case invalidGrade(min: Int, max: Int)
}
