//
//  LeaveCourseRequest.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

struct LeaveCourseRequestDTO: Equatable, Sendable, Codable {
    let courseId: String
    
    init(courseId: String) {
        self.courseId = courseId
    }
}
