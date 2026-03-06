//
//  GetMyCoursesUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public protocol GetMyCoursesUseCase: Sendable {
    func execute(page: Int, size: Int, role: CourseRole?) async throws -> PageCourse
}