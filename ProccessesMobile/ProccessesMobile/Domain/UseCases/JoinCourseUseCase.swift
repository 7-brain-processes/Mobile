//
//  JoinCourseUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public protocol JoinCourseUseCase: Sendable {
    func execute(code: String) async throws -> Course
}
