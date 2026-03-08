//
//  JoinCourseUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


protocol JoinCourseUseCase: Sendable {
    func execute(code: String) async throws -> Course
}
