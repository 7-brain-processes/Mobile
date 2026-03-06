//
//  MockJoinCourseUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

public struct MockJoinCourseUseCase: JoinCourseUseCase {
    private let repository: CourseMembershipRepository
    
    public init(repository: CourseMembershipRepository) {
        self.repository = repository
    }
    
    public func execute(code: String) async throws -> Course {
        let trimmedCode = code.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedCode.isEmpty else {
            throw MembershipValidationError.emptyInviteCode
        }
        
        return try await repository.joinCourse(code: trimmedCode)
    }
}
