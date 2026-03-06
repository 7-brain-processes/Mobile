//
//  MockLeaveCourseUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

public struct MockLeaveCourseUseCase: LeaveCourseUseCase {
    private let repository: CourseMembershipRepository
    
    public init(repository: CourseMembershipRepository) {
        self.repository = repository
    }
    
    public func execute(request: LeaveCourseRequest) async throws {
        guard !request.courseId.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw MembershipValidationError.emptyCourseId
        }
        
        try await repository.leaveCourse(courseId: request.courseId)
    }
}
