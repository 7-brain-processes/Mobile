//
//  JoinCourseCommand.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct JoinCourseCommand: Equatable, Sendable {
    let courseId: UUID
    let role: CourseRole
}
