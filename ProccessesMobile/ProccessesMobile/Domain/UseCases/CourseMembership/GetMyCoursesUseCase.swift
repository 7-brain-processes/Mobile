//
//  GetMyCoursesUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

protocol GetMyCoursesUseCase: Sendable {
    func execute(_ query: GetMyCoursesQuery) async throws -> Page<Course>
}
