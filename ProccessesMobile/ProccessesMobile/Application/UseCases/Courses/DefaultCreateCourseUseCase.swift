//
//  DefaultCreateCourseUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//


import Foundation

struct DefaultCreateCourseUseCase: CreateCourseUseCase {
    let repository: CourseRepository

    func execute(_ command: CreateCourseCommand) async throws -> Course {
        let name = command.name.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !name.isEmpty, name.count <= 200 else {
            throw CourseValidationError.invalidNameLength(min: 1, max: 200)
        }

        if let description = command.description, description.count > 2000 {
            throw CourseValidationError.invalidDescriptionLength(max: 2000)
        }

        let normalized = CreateCourseCommand(
            name: name,
            description: command.description
        )

        return try await repository.createCourse(normalized)
    }
}
