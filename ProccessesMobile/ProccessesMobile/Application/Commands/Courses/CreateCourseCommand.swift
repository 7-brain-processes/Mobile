//
//  CreateCourseCommand.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct CreateCourseCommand: Equatable, Sendable {
    let name: String
    let description: String?
}

extension CreateCourseCommand {
    func toDTO() -> CreateCourseRequestDTO {
        CreateCourseRequestDTO(
            name: name,
            description: description
        )
    }
}
