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
    
    func makeGetCoursesSUT(repo: CourseRepository) -> GetMyCoursesUseCase {
        return FakeGetMyCoursesUseCase(repository: repo)
    }
    
    func makeCreateCourseSUT(repo: CourseRepository) -> CreateCourseUseCase {
        return FakeCreateCourseUseCase(repository: repo)
    }
    
    // MARK: - Get My Courses
    
    @Test("Get courses forwards exact valid arguments and role", arguments: [
        (0, 20, CourseRole.teacher),
        (5, 50, CourseRole.student),
        (10, 100, nil)
    ])
    func getCoursesExactArguments(page: Int, size: Int, role: CourseRole?) async throws {
        let repoSpy =  CourseRepositorySpy()
        await repoSpy.setGetCoursesResult(.success(PageCourse(content: [], page: page, size: size, totalElements: 0, totalPages: 0)))
        let sut = makeGetCoursesSUT(repo: repoSpy)
        
        _ = try await sut.execute(page: page, size: size, role: role)
        
        let args = await repoSpy.recordedGetCoursesArgs
        #expect(args.count == 1)
        #expect(args.first?.page == page)
        #expect(args.first?.size == size)
        #expect(args.first?.role == role)
    }
    
    @Test("Get courses sanitizes out-of-bounds pagination before calling repo", arguments: [
        (-1, 20, 0, 20),         // Negative page becomes 0
        (0, 0, 0, 1),            // Size < 1 becomes 1
        (0, 150, 0, 100),        // Size > 100 becomes 100
        (-5, -10, 0, 1)          // Both negative sanitized
    ])
    func getCoursesPaginationSanitization(inputPage: Int, inputSize: Int, expectedPage: Int, expectedSize: Int) async throws {
        let repoSpy =  CourseRepositorySpy()
        await repoSpy.setGetCoursesResult(.success(PageCourse(content: [], page: 0, size: 20, totalElements: 0, totalPages: 0)))
        let sut = makeGetCoursesSUT(repo: repoSpy)
        
        _ = try await sut.execute(page: inputPage, size: inputSize, role: nil)
        
        let args = await repoSpy.recordedGetCoursesArgs
        #expect(args.first?.page == expectedPage)
        #expect(args.first?.size == expectedSize)
    }
    
    @Test("Get courses propagates repository errors")
    func getCoursesPropagatesErrors() async {
        let repoSpy =  CourseRepositorySpy()
        await repoSpy.setGetCoursesResult(.failure(APIError.unauthorized))
        let sut = makeGetCoursesSUT(repo: repoSpy)
        
        await #expect(throws: APIError.unauthorized) {
            try await sut.execute(page: 0, size: 20, role: nil)
        }
    }
    
    // MARK: - Create Course
    
    @Test("Create course allows exactly the boundary limits of OpenAPI spec", arguments: [
        CreateCourseRequest(name: "A"),
        CreateCourseRequest(name: String(repeating: "B", count: 200)),
        CreateCourseRequest(name: "Valid", description: String(repeating: "C", count: 2000)), 
        CreateCourseRequest(name: "Valid", description: nil)
    ])
    func createCourseBoundarySuccess(request: CreateCourseRequest) async throws {
        let repoSpy = CourseRepositorySpy()
        await repoSpy.setCreateCourseResult(.success(Course(id: "1", name: request.name, description: request.description, createdAt: "2026-03-06", currentUserRole: .teacher, teacherCount: 1, studentCount: 0)))
        let sut = makeCreateCourseSUT(repo: repoSpy)
        
        _ = try await sut.execute(request: request)
        let args = await repoSpy.recordedCreateCourseArgs
        #expect(args.count == 1)
        #expect(args.first?.request == request)
    }
}
