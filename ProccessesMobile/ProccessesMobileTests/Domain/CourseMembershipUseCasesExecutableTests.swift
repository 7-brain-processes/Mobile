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

    private func makeJoinSUT(repo: CourseMembershipRepository) -> JoinCourseUseCase {
        DefaultJoinCourseUseCase(repository: repo)
    }

    private func makeLeaveSUT(repo: CourseMembershipRepository) -> LeaveCourseUseCase {
        DefaultLeaveCourseUseCase(repository: repo)
    }

    // MARK: - Join Course Tests

    @Test("Join course delegates properly using invite code and returns Course")
    func joinCourseSuccess() async throws {

        let expectedCourse = Course(
            id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!,
            name: "iOS Dev",
            description: nil,
            createdAt: Date(),
            currentUserRole: .student,
            teacherCount: 1,
            studentCount: 1
        )

        let repoSpy = CourseMembershipRepositorySpy()
        await repoSpy.setJoinResult(.success(expectedCourse))

        let sut = makeJoinSUT(repo: repoSpy)

        let result = try await sut.execute(
            JoinCourseCodeCommand(code: "aBcD1234")
        )

        #expect(result == expectedCourse)

        let commands = await repoSpy.getRecordedJoinCommands()
        #expect(commands.count == 1)
        #expect(commands.first?.code == "aBcD1234")
    }

    @Test("Join course trims whitespace before delegating")
    func joinCourseTrimsCode() async throws {

        let expectedCourse = Course(
            id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440002")!,
            name: "Algorithms",
            description: nil,
            createdAt: Date(),
            currentUserRole: .student,
            teacherCount: 1,
            studentCount: 5
        )

        let repoSpy = CourseMembershipRepositorySpy()
        await repoSpy.setJoinResult(.success(expectedCourse))

        let sut = makeJoinSUT(repo: repoSpy)

        _ = try await sut.execute(
            JoinCourseCodeCommand(code: "  aBcD1234 \n")
        )

        let commands = await repoSpy.getRecordedJoinCommands()
        #expect(commands.count == 1)
        #expect(commands.first?.code == "aBcD1234")
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
            _ = try await sut.execute(
                JoinCourseCodeCommand(code: invalidCode)
            )
        }

        let commands = await repoSpy.getRecordedJoinCommands()
        #expect(commands.isEmpty)
    }

    // MARK: - Leave Course Tests

    @Test("Leave course delegates properly")
    func leaveCourseSuccess() async throws {

        let repoSpy = CourseMembershipRepositorySpy()
        let sut = makeLeaveSUT(repo: repoSpy)

        let command = LeaveCourseCommand(
            courseId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440999")!
        )

        try await sut.execute(command)

        let commands = await repoSpy.getRecordedLeaveCommands()
        #expect(commands.count == 1)
        #expect(commands.first?.courseId == command.courseId)
    }

    @Test("Leave course propagates repository errors")
    func leaveCoursePropagatesError() async {

        let repoSpy = CourseMembershipRepositorySpy()
        await repoSpy.setLeaveResult(.failure(APIError.serverError(code: 404)))

        let sut = makeLeaveSUT(repo: repoSpy)

        await #expect(throws: APIError.serverError(code: 404)) {
            try await sut.execute(
                LeaveCourseCommand(
                    courseId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440999")!
                )
            )
        }
    }
}
