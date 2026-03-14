//
//  CreateCourseRequest.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

struct CreateCourseRequestDTO: Equatable, Sendable, Codable {
    let name: String
    let description: String?
}
