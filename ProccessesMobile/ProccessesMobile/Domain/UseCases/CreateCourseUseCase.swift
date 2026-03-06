//
//  CreateCourseUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public protocol CreateCourseUseCase: Sendable {
    func execute(request: CreateCourseRequest) async throws -> Course
}