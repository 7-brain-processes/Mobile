//
//  LeaveCourseUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

protocol LeaveCourseUseCase: Sendable {
    func execute(_ command: LeaveCourseCommand) async throws
}
