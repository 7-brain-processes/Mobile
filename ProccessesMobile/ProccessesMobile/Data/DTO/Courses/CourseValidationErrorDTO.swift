//
//  CourseValidationError.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

enum CourseValidationErrorDTO: Error, Equatable, Sendable {
    case invalidNameLength(min: Int, max: Int)
    case invalidDescriptionLength(max: Int)
    case emptyCourseId
}
