//
//  MockRevokeInviteUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct MockRevokeInviteUseCase: RevokeInviteUseCase {
    private let repository: CourseInvitesRepository
    
    init(repository: CourseInvitesRepository) { self.repository = repository }
    
    func execute(courseId: String, inviteId: String) async throws {
        guard !courseId.trimmingCharacters(in: .whitespaces).isEmpty else { throw CourseUsersValidationError.emptyCourseId }
        guard !inviteId.trimmingCharacters(in: .whitespaces).isEmpty else { throw CourseUsersValidationError.emptyInviteId }
        
        try await repository.revokeInvite(courseId: courseId, inviteId: inviteId)
    }
}
