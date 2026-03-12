//
//  UpdateCourseCommand.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct UpdateCourseCommand: Equatable, Sendable {
    let courseId: UUID
    let name: String?
    let description: String?
}
