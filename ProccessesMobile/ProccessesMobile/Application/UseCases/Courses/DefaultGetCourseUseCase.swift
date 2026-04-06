//
//  DefaultGetCourseUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//


import Foundation

struct DefaultGetCourseUseCase: GetCourseUseCase {
    private let repository: CourseDetailsRepository

    init(repository: CourseDetailsRepository) {
        self.repository = repository
    }

    func execute(_ query: GetCourseQuery) async throws -> Course {
        try await repository.getCourse(query)
    }
}