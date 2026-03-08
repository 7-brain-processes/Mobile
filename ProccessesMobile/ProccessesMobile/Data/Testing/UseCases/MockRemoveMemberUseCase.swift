//
//  MockRemoveMemberUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct MockRemoveMemberUseCase: RemoveMemberUseCase {
    private let repository: CourseMembersRepository
    
    init(repository: CourseMembersRepository) { self.repository = repository }
    
    func execute(courseId: String, userId: String) async throws {
        guard !courseId.trimmingCharacters(in: .whitespaces).isEmpty else { throw CourseUsersValidationError.emptyCourseId }
        guard !userId.trimmingCharacters(in: .whitespaces).isEmpty else { throw CourseUsersValidationError.emptyUserId }
        
        try await repository.removeMember(courseId: courseId, userId: userId)
    }
}
