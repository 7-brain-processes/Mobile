//
//  JoinCourseRequest.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public struct JoinCourseRequest: Equatable, Sendable, Codable {
    public let courseId: String
    public let role: CourseRole
    
    public init(courseId: String, role: CourseRole) {
        self.courseId = courseId
        self.role = role
    }
}
