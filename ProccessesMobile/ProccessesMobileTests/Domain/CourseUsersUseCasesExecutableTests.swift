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

    // MARK: - Factories

    private func makeRemoveSUT(repo: CourseMembersRepository) -> RemoveMemberUseCase {
        DefaultRemoveMemberUseCase(repository: repo)
    }

    private func makeCreateInviteSUT(repo: CourseInvitesRepository) -> CreateInviteUseCase {
        DefaultCreateInviteUseCase(repository: repo)
    }

    private func makeRevokeInviteSUT(repo: CourseInvitesRepository) -> DefaultRevokeInviteUseCase {
        DefaultRevokeInviteUseCase(repository: repo)
    }

    // MARK: - Remove Member Tests

    @Test("Remove member delegates properly to repository")
    func removeMemberSuccess() async throws {

        let repoSpy = CourseMembersRepositorySpy()
        let sut = makeRemoveSUT(repo: repoSpy)

        let command = RemoveMemberCommand(
            courseId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!,
            userId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440002")!
        )

        try await sut.execute(command)

        let commands = await repoSpy.getRecordedRemoveCommands()

        #expect(commands.count == 1)
        #expect(commands.first?.courseId == command.courseId)
        #expect(commands.first?.userId == command.userId)
    }

    // MARK: - Create Invite Tests

    @Test("Create invite delegates and validates maxUses")
    func createInviteSuccess() async throws {

        let repoSpy = CourseInvitesRepositorySpy()

        let expectedInvite = Invite(
            id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440111")!,
            code: "ABCD",
            role: .student,
            expiresAt: nil,
            maxUses: 5,
            currentUses: 0,
            createdAt: Date()
        )

        await repoSpy.setCreateResult(.success(expectedInvite))

        let sut = makeCreateInviteSUT(repo: repoSpy)

        let command = CreateInviteCommand(
            courseId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!,
            role: .student,
            expiresAt: nil,
            maxUses: 5
        )

        let result = try await sut.execute(command)

        #expect(result == expectedInvite)

        let commands = await repoSpy.getRecordedCreateCommands()

        #expect(commands.count == 1)
        #expect(commands.first?.maxUses == 5)
    }

    @Test("Create invite fails on negative or zero maxUses")
    func createInviteInvalidMaxUses() async {

        let repoSpy = CourseInvitesRepositorySpy()
        let sut = makeCreateInviteSUT(repo: repoSpy)

        await #expect(throws: CourseUsersValidationError.invalidMaxUses(minimum: 1)) {
            _ = try await sut.execute(
                CreateInviteCommand(
                    courseId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!,
                    role: .teacher,
                    expiresAt: nil,
                    maxUses: 0
                )
            )
        }

        let commands = await repoSpy.getRecordedCreateCommands()
        #expect(commands.isEmpty)
    }

    // MARK: - Revoke Invite Tests

    @Test("Revoke invite delegates properly")
    func revokeInviteSuccess() async throws {

        let repoSpy = CourseInvitesRepositorySpy()
        let sut = makeRevokeInviteSUT(repo: repoSpy)

        let command = RevokeInviteCommand(
            courseId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!,
            inviteId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440111")!
        )

        try await sut.execute(command)

        let commands = await repoSpy.getRecordedRevokeCommands()

        #expect(commands.count == 1)
        #expect(commands.first?.inviteId == command.inviteId)
    }
}
