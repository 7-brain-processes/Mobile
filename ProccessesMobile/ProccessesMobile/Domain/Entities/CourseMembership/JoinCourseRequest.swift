//
//  JoinCourseRequest.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


struct JoinCourseRequest: Equatable, Sendable, Codable {
    let courseId: String
    let role: CourseRole
    
    init(courseId: String, role: CourseRole) {
        self.courseId = courseId
        self.role = role
    }
}
