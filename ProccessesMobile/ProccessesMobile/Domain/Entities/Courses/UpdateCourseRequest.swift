//
//  UpdateCourseRequest.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public struct UpdateCourseRequest: Equatable, Sendable, Codable {
    public let name: String?
    public let description: String?
    
    public init(name: String? = nil, description: String? = nil) {
        self.name = name
        self.description = description
    }
}
