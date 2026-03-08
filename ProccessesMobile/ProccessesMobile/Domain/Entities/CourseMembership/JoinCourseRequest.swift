//
//  JoinCourseRequest.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct JoinCourseRequest: Equatable, Sendable, Codable {
    let courseId: UUID
    let role: CourseRole
    
    init(courseId: UUID, role: CourseRole) {
        self.courseId = courseId
        self.role = role
    }
}
