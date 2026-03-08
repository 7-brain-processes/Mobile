//
//  LeaveCourseRequest.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct LeaveCourseRequest: Equatable, Sendable, Codable {
    let courseId: UUID
    
    init(courseId: UUID) {
        self.courseId = courseId
    }
}
