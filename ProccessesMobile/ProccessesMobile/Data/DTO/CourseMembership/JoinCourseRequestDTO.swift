//
//  JoinCourseRequest.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

struct JoinCourseRequestDTO: Equatable, Sendable, Codable {
    let courseId: String
    let role: CourseRoleDTO
}
