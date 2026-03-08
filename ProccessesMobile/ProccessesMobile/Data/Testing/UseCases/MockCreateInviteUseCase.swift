//
//  MockCreateInviteUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct MockCreateInviteUseCase: CreateInviteUseCase {
    private let repository: CourseInvitesRepository
    
    init(repository: CourseInvitesRepository) { self.repository = repository }
    
    func execute(courseId: String, request: CreateInviteRequest) async throws -> Invite {
        guard !courseId.trimmingCharacters(in: .whitespaces).isEmpty else { throw CourseUsersValidationError.emptyCourseId }
        
        if let maxUses = request.maxUses, maxUses < 1 {
            throw CourseUsersValidationError.invalidMaxUses(minimum: 1)
        }
        
        return try await repository.createInvite(courseId: courseId, request: request)
    }
}
