//
//  CourseInvitesRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public protocol CourseInvitesRepository: Sendable {
    func listInvites(courseId: String) async throws -> [Invite]
    func createInvite(courseId: String, request: CreateInviteRequest) async throws -> Invite
    func revokeInvite(courseId: String, inviteId: String) async throws
}