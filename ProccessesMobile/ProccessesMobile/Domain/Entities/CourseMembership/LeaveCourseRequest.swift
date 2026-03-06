//
//  LeaveCourseRequest.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public struct LeaveCourseRequest: Equatable, Sendable, Codable {
    public let courseId: String
    
    public init(courseId: String) {
        self.courseId = courseId
    }
}
