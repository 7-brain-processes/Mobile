//
//  CourseValidationError.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

enum CourseValidationError: Error, Equatable, Sendable {
    case invalidNameLength(min: Int, max: Int)
    case invalidDescriptionLength(max: Int)
    case emptyCourseId
}
