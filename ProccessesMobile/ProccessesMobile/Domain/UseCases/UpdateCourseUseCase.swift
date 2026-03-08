//
//  UpdateCourseUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


protocol UpdateCourseUseCase: Sendable {
    func execute(courseId: String, request: UpdateCourseRequest) async throws -> Course
}