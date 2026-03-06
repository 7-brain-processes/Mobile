//
//  CourseMembershipUseCasesExecutableTests.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


import Testing
import Foundation
@testable import ProccessesMobile

@Suite("Course Membership Domain: Executable Specification")
struct CourseMembershipUseCasesExecutableTests {
    
    // MARK: - Factories
    
    func makeJoinSUT(repo: CourseMembershipRepository) -> JoinCourseUseCase {
        return MockJoinCourseUseCase(repository: repo)
    }
    
    func makeLeaveSUT(repo: CourseMembershipRepository) -> LeaveCourseUseCase {
        return MockLeaveCourseUseCase(repository: repo)
    }
    
    // MARK: - Join Course Tests
    
    @Test("Join course delegates properly using invite code and returns Course")
    func joinCourseSuccess() async throws {
        let expectedCourse = Course(id: "course_123", name: "iOS Dev", description: nil, createdAt: "2026-03-06", currentUserRole: .student, teacherCount: 1, studentCount: 1)
        
        let repoSpy = CourseMembershipRepositorySpy()
        await repoSpy.setJoinResult(.success(expectedCourse))
        let sut = makeJoinSUT(repo: repoSpy)
        
        let result = try await sut.execute(code: "aBcD1234")
        
        #expect(result == expectedCourse)
        
        let args = await repoSpy.getRecordedJoinArgs()
        #expect(args.count == 1)
        #expect(args.first == "aBcD1234")
    }
    
    @Test("Join course validation halts on empty invite code", arguments: [
        "",
        "   ",
        "\n\t"
    ])
    func joinCourseEmptyCodeValidation(invalidCode: String) async {
        let repoSpy = CourseMembershipRepositorySpy()
        let sut = makeJoinSUT(repo: repoSpy)
        
        await #expect(throws: MembershipValidationError.emptyInviteCode) {
            _ = try await sut.execute(code: invalidCode)
        }
        
        let args = await repoSpy.getRecordedJoinArgs()
        #expect(args.isEmpty, "Repository should not be called with an invalid code")
    }
    
    // MARK: - Leave Course Tests
    
    @Test("Leave course delegates properly")
    func leaveCourseSuccess() async throws {
        let repoSpy = CourseMembershipRepositorySpy()
        let sut = makeLeaveSUT(repo: repoSpy)
        
        try await sut.execute(request: LeaveCourseRequest(courseId: "course_999"))
        
        let args = await repoSpy.getRecordedLeaveArgs()
        #expect(args.count == 1)
        #expect(args.first == "course_999")
    }
    
    @Test("Leave course validation halts on empty course ID", arguments: [
        "",
        "   "
    ])
    func leaveCourseEmptyIdValidation(invalidId: String) async {
        let repoSpy = CourseMembershipRepositorySpy()
        let sut = makeLeaveSUT(repo: repoSpy)
        
        await #expect(throws: MembershipValidationError.emptyCourseId) {
             try await sut.execute(request: LeaveCourseRequest(courseId: invalidId))
        }
        
        let args = await repoSpy.getRecordedLeaveArgs()
        #expect(args.isEmpty)
    }
    
    @Test("Leave course propagates repository errors")
    func leaveCoursePropagatesError() async {
        let repoSpy = CourseMembershipRepositorySpy()
        await repoSpy.setLeaveResult(.failure(APIError.serverError(code: 404)))
        let sut = makeLeaveSUT(repo: repoSpy)
        
        await #expect(throws: APIError.serverError(code: 404)) {
            try await sut.execute(request:  LeaveCourseRequest(courseId: "missing_course"))
        }
    }
}
