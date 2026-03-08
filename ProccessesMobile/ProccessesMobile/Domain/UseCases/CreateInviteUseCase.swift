//
//  CreateInviteUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


protocol CreateInviteUseCase: Sendable {
    func execute(courseId: String, request: CreateInviteRequest) async throws -> Invite
}
