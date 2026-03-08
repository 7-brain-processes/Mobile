//
//  UpdateCourseRequest.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


struct UpdateCourseRequest: Equatable, Sendable, Codable {
    let name: String?
    let description: String?
    
    init(name: String? = nil, description: String? = nil) {
        self.name = name
        self.description = description
    }
}
