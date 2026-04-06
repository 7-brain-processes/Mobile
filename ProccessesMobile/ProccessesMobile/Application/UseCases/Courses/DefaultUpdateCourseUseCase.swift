//
//  DefaultUpdateCourseUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//


import Foundation

struct DefaultUpdateCourseUseCase: UpdateCourseUseCase {
    private let repository: CourseDetailsRepository

    init(repository: CourseDetailsRepository) {
        self.repository = repository
    }

    func execute(_ command: UpdateCourseCommand) async throws -> Course {
        if let name = command.name {
            let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedName.isEmpty, trimmedName.count <= 200 else {
                throw CourseValidationError.invalidNameLength(min: 1, max: 200)
            }
        }

        if let description = command.description, description.count > 2000 {
            throw CourseValidationError.invalidDescriptionLength(max: 2000)
        }

        return try await repository.updateCourse(command)
    }
}