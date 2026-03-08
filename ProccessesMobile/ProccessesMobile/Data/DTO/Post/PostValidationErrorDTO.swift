//
//  PostValidationError.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

enum PostValidationErrorDTO: Error, Equatable, Sendable {
    case invalidTitleLength(min: Int, max: Int)
    case invalidContentLength(max: Int)
    case emptyCourseId
    case emptyPostId
}
