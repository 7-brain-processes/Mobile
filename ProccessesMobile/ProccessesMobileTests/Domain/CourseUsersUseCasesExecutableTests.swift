//
//  CourseUsersUseCasesExecutableTests.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


import Testing
import Foundation
@testable import ProccessesMobile

@Suite("Course Users Management Domain: Executable Specification")
struct CourseUsersUseCasesExecutableTests {
    
    func makeRemoveSUT(repo: CourseMembersRepository) -> RemoveMemberUseCase { return MockRemoveMemberUseCase(repository: repo) }
    func makeCreateInviteSUT(repo: CourseInvitesRepository) -> CreateInviteUseCase { return MockCreateInviteUseCase(repository: repo) }
    func makeRevokeInviteSUT(repo: CourseInvitesRepository) -> RevokeInviteUseCase { return MockRevokeInviteUseCase(repository: repo) }
    
    // MARK: - Remove Member (Ban) Tests
    
    @Test("Remove member delegates properly to repository")
    func removeMemberSuccess() async throws {
        let repoSpy = CourseMembersRepositorySpy()
        let sut = makeRemoveSUT(repo: repoSpy)
        
        try await sut.execute(courseId: "course_1", userId: "user_99")
        
        let args = await repoSpy.getRecordedRemoveArgs()
        #expect(args.count == 1)
        #expect(args.first?.courseId == "course_1")
        #expect(args.first?.userId == "user_99")
    }
    
    @Test("Remove member catches empty ID inputs", arguments: [
        (" ", "user_99", CourseUsersValidationError.emptyCourseId),
        ("course_1", "   ", CourseUsersValidationError.emptyUserId)
    ])
    func removeMemberValidations(cId: String, uId: String, expectedErr: CourseUsersValidationError) async {
        let repoSpy = CourseMembersRepositorySpy()
        let sut = makeRemoveSUT(repo: repoSpy)
        
        await #expect(throws: expectedErr) {
            try await sut.execute(courseId: cId, userId: uId)
        }
        
        let args = await repoSpy.getRecordedRemoveArgs()
        #expect(args.isEmpty)
    }
    
    // MARK: - Create Invite Tests
    
    @Test("Create invite delegates and validates maxUses")
    func createInviteSuccess() async throws {
        let repoSpy = CourseInvitesRepositorySpy()
        let expectedInvite = Invite(id: "inv_1", code: "ABCD", role: .student, expiresAt: nil, maxUses: 5, currentUses: 0, createdAt: "2026-03-06")
        await repoSpy.setCreateResult(.success(expectedInvite))
        
        let sut = makeCreateInviteSUT(repo: repoSpy)
        let result = try await sut.execute(courseId: "course_1", request: CreateInviteRequest(role: .student, expiresAt: nil, maxUses: 5))
        
        #expect(result == expectedInvite)
        let args = await repoSpy.getRecordedCreateArgs()
        #expect(args.first?.request.maxUses == 5)
    }
    
    @Test("Create invite fails on negative or zero maxUses")
    func createInviteInvalidMaxUses() async {
        let repoSpy = CourseInvitesRepositorySpy()
        let sut = makeCreateInviteSUT(repo: repoSpy)
        
        await #expect(throws: CourseUsersValidationError.invalidMaxUses(minimum: 1)) {
            let _ = try await sut.execute(courseId: "course_1", request: CreateInviteRequest(role: .teacher, expiresAt: nil, maxUses: 0))
        }
    }
    
    // MARK: - Revoke Invite Tests
    
    @Test("Revoke invite catches empty IDs")
    func revokeInviteValidations() async {
        let repoSpy = CourseInvitesRepositorySpy()
        let sut = makeRevokeInviteSUT(repo: repoSpy)
        
        await #expect(throws: CourseUsersValidationError.emptyInviteId) {
            try await sut.execute(courseId: "course_1", inviteId: "   ")
        }
    }
}