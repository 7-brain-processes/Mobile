//
//  UpdateCourseRequest.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

import Foundation

struct UpdateCourseRequestDTO: Equatable, Sendable, Codable {
    let name: String?
    let description: String?
}

extension UpdateCourseRequestDTO {
    func toCommand(courseId: UUID) -> UpdateCourseCommand {
        UpdateCourseCommand(
            courseId: courseId,
            name: name,
            description: description
        )
    }
}
