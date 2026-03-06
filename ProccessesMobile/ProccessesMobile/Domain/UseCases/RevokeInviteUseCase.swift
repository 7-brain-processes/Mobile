//
//  RevokeInviteUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public protocol RevokeInviteUseCase: Sendable {
    func execute(courseId: String, inviteId: String) async throws
}