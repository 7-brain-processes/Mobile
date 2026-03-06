//
//  GetCourseUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public protocol GetCourseUseCase: Sendable {
    func execute(courseId: String) async throws -> Course
}