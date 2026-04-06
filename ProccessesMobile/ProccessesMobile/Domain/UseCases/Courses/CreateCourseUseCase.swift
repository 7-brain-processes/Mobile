//
//  CreateCourseUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

protocol CreateCourseUseCase: Sendable {
    func execute(_ command: CreateCourseCommand) async throws -> Course
}
