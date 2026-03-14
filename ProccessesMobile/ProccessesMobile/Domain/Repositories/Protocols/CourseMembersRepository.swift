//
//  CourseMembersRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

protocol CourseMembersRepository: Sendable {
    func listMembers(_ query: ListMembersQuery) async throws -> Page<Member>
    func removeMember(_ command: RemoveMemberCommand) async throws
}
