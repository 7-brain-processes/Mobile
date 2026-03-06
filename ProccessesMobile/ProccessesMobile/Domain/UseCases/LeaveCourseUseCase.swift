//
//  LeaveCourseUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public protocol LeaveCourseUseCase: Sendable {
    func execute(request: LeaveCourseRequest) async throws
}