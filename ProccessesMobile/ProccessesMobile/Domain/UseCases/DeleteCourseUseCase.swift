//
//  DeleteCourseUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public protocol DeleteCourseUseCase: Sendable {
    func execute(courseId: String) async throws
}