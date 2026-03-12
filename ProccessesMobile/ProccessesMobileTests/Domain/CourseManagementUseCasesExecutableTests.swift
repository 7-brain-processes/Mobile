//
//  CourseManagementUseCasesExecutableTests.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


import Testing
import Foundation
@testable import ProccessesMobile

@Suite("Course Management Domain: Executable Specification")
struct CourseManagementUseCasesExecutableTests {

    // MARK: - Factories

    private func makeGetSUT(repo: CourseDetailsRepository) -> GetCourseUseCase {
        DefaultGetCourseUseCase(repository: repo)
    }

    private func makeUpdateSUT(repo: CourseDetailsRepository) -> UpdateCourseUseCase {
        DefaultUpdateCourseUseCase(repository: repo)
    }

    private func makeDeleteSUT(repo: CourseDetailsRepository) -> DeleteCourseUseCase {
        //TODO: Default
        DefaultDeleteCourseUseCase(repository: repo)
    }

    // MARK: - Get Course Tests

    @Test("Get course delegates properly")
    func getCourseSuccess() async throws {
        let expectedCourse = Course(
            id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!,
            name: "iOS Dev",
            description: nil,
            createdAt: Date(),
            currentUserRole: .student,
            teacherCount: 1,
            studentCount: 10
        )

        let repoSpy = CourseDetailsRepositorySpy()
        await repoSpy.setGetResult(.success(expectedCourse))

        let sut = makeGetSUT(repo: repoSpy)

        let query = GetCourseQuery(
            courseId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!
        )

        let result = try await sut.execute(query)

        #expect(result == expectedCourse)

        let queries = await repoSpy.getRecordedGetQueries()
        #expect(queries.count == 1)
        #expect(queries.first?.courseId == query.courseId)
    }

    // MARK: - Update Course Tests

    @Test("Update course delegates successfully")
    func updateCourseSuccess() async throws {
        let expectedCourse = Course(
            id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!,
            name: "Updated Name",
            description: nil,
            createdAt: Date(),
            currentUserRole: .teacher,
            teacherCount: 1,
            studentCount: 0
        )

        let repoSpy = CourseDetailsRepositorySpy()
        await repoSpy.setUpdateResult(.success(expectedCourse))

        let sut = makeUpdateSUT(repo: repoSpy)

        let command = UpdateCourseCommand(
            courseId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!,
            name: "Updated Name",
            description: nil
        )

        let result = try await sut.execute(command)

        #expect(result == expectedCourse)

        let commands = await repoSpy.getRecordedUpdateCommands()
        #expect(commands.count == 1)
        #expect(commands.first?.courseId == command.courseId)
        #expect(commands.first?.name == "Updated Name")
    }

    @Test("Update course validation catches invalid optional name length")
    func updateCourseInvalidName() async {
        let repoSpy = CourseDetailsRepositorySpy()
        let sut = makeUpdateSUT(repo: repoSpy)

        let command = UpdateCourseCommand(
            courseId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!,
            name: "",
            description: "Valid"
        )

        await #expect(throws: CourseValidationError.invalidNameLength(min: 1, max: 200)) {
            _ = try await sut.execute(command)
        }

        let commands = await repoSpy.getRecordedUpdateCommands()
        #expect(commands.isEmpty)
    }

    // MARK: - Delete Course Tests

    @Test("Delete course delegates successfully")
    func deleteCourseSuccess() async throws {
        let repoSpy = CourseDetailsRepositorySpy()
        let sut = makeDeleteSUT(repo: repoSpy)

        let query = DeleteCourseQuery(
            courseId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440999")!
        )

        try await sut.execute(query)

        let queries = await repoSpy.getRecordedDeleteQueries()
        #expect(queries.count == 1)
        #expect(queries.first?.courseId == query.courseId)
    }

    @Test("Delete course propagates 404 Not Found error")
    func deleteCoursePropagatesError() async {
        let repoSpy = CourseDetailsRepositorySpy()
        await repoSpy.setDeleteResult(.failure(APIError.serverError(code: 404)))

        let sut = makeDeleteSUT(repo: repoSpy)

        await #expect(throws: APIError.serverError(code: 404)) {
            try await sut.execute(
                DeleteCourseQuery(
                    courseId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440999")!
                )
            )
        }
    }
}
