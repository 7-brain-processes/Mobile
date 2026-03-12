//
//  CoursesUseCasesExecutableTests.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


import Testing
import Foundation
@testable import ProccessesMobile

@Suite("Courses Domain: Expanded Use Cases Specification")
struct CoursesUseCasesExecutableTests {

    // MARK: - Factories

    private func makeGetCoursesSUT(repo: CourseRepository) -> GetMyCoursesUseCase {
        DefaultGetMyCoursesUseCase(repository: repo)
    }

    private func makeCreateCourseSUT(repo: CourseRepository) -> CreateCourseUseCase {
        DefaultCreateCourseUseCase(repository: repo)
    }

    // MARK: - Get My Courses

    @Test("Get courses forwards exact valid arguments and role", arguments: [
        (0, 20, CourseRole.teacher),
        (5, 50, CourseRole.student),
        (10, 100, nil)
    ])
    func getCoursesExactArguments(page: Int, size: Int, role: CourseRole?) async throws {

        let repoSpy = CourseRepositorySpy()

        await repoSpy.setGetCoursesResult(
            .success(
                Page(
                    content: [],
                    page: page,
                    size: size,
                    totalElements: 0,
                    totalPages: 0
                )
            )
        )

        let sut = makeGetCoursesSUT(repo: repoSpy)

        _ = try await sut.execute(
            GetMyCoursesQuery(
                page: page,
                size: size,
                role: role
            )
        )

        let queries = await repoSpy.getRecordedGetCoursesQueries()

        #expect(queries.count == 1)
        #expect(queries.first?.page == page)
        #expect(queries.first?.size == size)
        #expect(queries.first?.role == role)
    }

    @Test("Get courses sanitizes out-of-bounds pagination before calling repo", arguments: [
        (-1, 20, 0, 20),
        (0, 0, 0, 1),
        (0, 150, 0, 100),
        (-5, -10, 0, 1)
    ])
    func getCoursesPaginationSanitization(
        inputPage: Int,
        inputSize: Int,
        expectedPage: Int,
        expectedSize: Int
    ) async throws {

        let repoSpy = CourseRepositorySpy()

        await repoSpy.setGetCoursesResult(
            .success(
                Page(
                    content: [],
                    page: 0,
                    size: 20,
                    totalElements: 0,
                    totalPages: 0
                )
            )
        )

        let sut = makeGetCoursesSUT(repo: repoSpy)

        _ = try await sut.execute(
            GetMyCoursesQuery(
                page: inputPage,
                size: inputSize,
                role: nil
            )
        )

        let queries = await repoSpy.getRecordedGetCoursesQueries()

        #expect(queries.first?.page == expectedPage)
        #expect(queries.first?.size == expectedSize)
    }

    @Test("Get courses propagates repository errors")
    func getCoursesPropagatesErrors() async {

        let repoSpy = CourseRepositorySpy()
        await repoSpy.setGetCoursesResult(.failure(APIError.unauthorized))

        let sut = makeGetCoursesSUT(repo: repoSpy)

        await #expect(throws: APIError.unauthorized) {
            try await sut.execute(
                GetMyCoursesQuery(
                    page: 0,
                    size: 20,
                    role: nil
                )
            )
        }
    }

    // MARK: - Create Course

    @Test("Create course allows exactly the boundary limits of OpenAPI spec", arguments: [
        CreateCourseCommand(name: "A", description: nil),
        CreateCourseCommand(name: String(repeating: "B", count: 200), description: nil),
        CreateCourseCommand(name: "Valid", description: String(repeating: "C", count: 2000)),
        CreateCourseCommand(name: "Valid", description: nil)
    ])
    func createCourseBoundarySuccess(command: CreateCourseCommand) async throws {

        let repoSpy = CourseRepositorySpy()

        await repoSpy.setCreateCourseResult(
            .success(
                Course(
                    id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!,
                    name: command.name,
                    description: command.description,
                    createdAt: Date(),
                    currentUserRole: .teacher,
                    teacherCount: 1,
                    studentCount: 0
                )
            )
        )

        let sut = makeCreateCourseSUT(repo: repoSpy)

        _ = try await sut.execute(command)

        let commands = await repoSpy.getRecordedCreateCourseCommands()

        #expect(commands.count == 1)
        #expect(commands.first?.name == command.name)
        #expect(commands.first?.description == command.description)
    }
}
