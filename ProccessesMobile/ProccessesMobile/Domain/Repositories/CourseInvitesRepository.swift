//
//  CourseInvitesRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

protocol CourseInvitesRepository: Sendable {
    func listInvites(courseId: UUID) async throws -> [Invite]
    func createInvite(_ command: CreateInviteCommand) async throws -> Invite
    func revokeInvite(_ command: RevokeInviteCommand) async throws
}
