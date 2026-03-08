//
//  LeaveCourseRequest.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


struct LeaveCourseRequest: Equatable, Sendable, Codable {
    let courseId: String
    
    init(courseId: String) {
        self.courseId = courseId
    }
}
