//
//  RemoveMemberUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


protocol RemoveMemberUseCase: Sendable {
    func execute(courseId: String, userId: String) async throws
}