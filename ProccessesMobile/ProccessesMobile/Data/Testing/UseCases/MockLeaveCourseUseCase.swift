//
//  MockLeaveCourseUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct MockLeaveCourseUseCase: LeaveCourseUseCase {
    private let repository: CourseMembershipRepository
    
    init(repository: CourseMembershipRepository) {
        self.repository = repository
    }
    
    func execute(request: LeaveCourseRequest) async throws {
        guard !request.courseId.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw MembershipValidationError.emptyCourseId
        }
        
        try await repository.leaveCourse(courseId: request.courseId)
    }
}
