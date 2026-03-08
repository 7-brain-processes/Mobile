//
//  RevokeInviteUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


protocol RevokeInviteUseCase: Sendable {
    func execute(courseId: String, inviteId: String) async throws
}