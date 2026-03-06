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
    
    func makeGetSUT(repo: CourseDetailsRepository) -> GetCourseUseCase {
        return MockGetCourseUseCase(repository: repo)
    }
    
    func makeUpdateSUT(repo: CourseDetailsRepository) -> UpdateCourseUseCase {
        return MockUpdateCourseUseCase(repository: repo)
    }
    
    func makeDeleteSUT(repo: CourseDetailsRepository) -> DeleteCourseUseCase {
        return MockDeleteCourseUseCase(repository: repo)
    }
    
    // MARK: - Get Course Tests
    
    @Test("Get course trims whitespaces and delegates properly")
    func getCourseSuccess() async throws {
        let expectedCourse = Course(id: "c_1", name: "iOS Dev", description: nil, createdAt: "2026-03-06", currentUserRole: .student, teacherCount: 1, studentCount: 10)
        let repoSpy = CourseDetailsRepositorySpy()
        await repoSpy.setGetResult(.success(expectedCourse))
        
        let sut = makeGetSUT(repo: repoSpy)
        let result = try await sut.execute(courseId: "  c_1  ")
        
        #expect(result == expectedCourse)
        let args = await repoSpy.getRecordedGetArgs()
        #expect(args.count == 1)
        #expect(args.first == "c_1")
    }
    
    @Test("Get course validation catches empty ID")
    func getCourseEmptyId() async {
        let repoSpy = CourseDetailsRepositorySpy()
        let sut = makeGetSUT(repo: repoSpy)
        
        await #expect(throws: CourseValidationError.emptyCourseId) {
            try await sut.execute(courseId: "   ")
        }
        
        let args = await repoSpy.getRecordedGetArgs()
        #expect(args.isEmpty)
    }
    
    // MARK: - Update Course Tests
    
    @Test("Update course delegates successfully")
    func updateCourseSuccess() async throws {
        let expectedCourse = Course(id: "c_1", name: "Updated Name", description: nil, createdAt: "", currentUserRole: .teacher, teacherCount: 1, studentCount: 0)
        let repoSpy = CourseDetailsRepositorySpy()
        await repoSpy.setUpdateResult(.success(expectedCourse))
        
        let sut = makeUpdateSUT(repo: repoSpy)
        let request = UpdateCourseRequest(name: "Updated Name", description: nil)
        
        let result = try await sut.execute(courseId: "c_1", request: request)
        
        #expect(result == expectedCourse)
        let args = await repoSpy.getRecordedUpdateArgs()
        #expect(args.count == 1)
        #expect(args.first?.id == "c_1")
        #expect(args.first?.req.name == "Updated Name")
    }
    
    @Test("Update course validation catches invalid optional name length")
    func updateCourseInvalidName() async {
        let repoSpy = CourseDetailsRepositorySpy()
        let sut = makeUpdateSUT(repo: repoSpy)
        
        let request = UpdateCourseRequest(name: "", description: "Valid")
        
        await #expect(throws: CourseValidationError.invalidNameLength(min: 1, max: 200)) {
            try await sut.execute(courseId: "c_1", request: request)
        }
        
        let args = await repoSpy.getRecordedUpdateArgs()
        #expect(args.isEmpty)
    }
    
    // MARK: - Delete Course Tests
    
    @Test("Delete course delegates successfully")
    func deleteCourseSuccess() async throws {
        let repoSpy = CourseDetailsRepositorySpy()
        let sut = makeDeleteSUT(repo: repoSpy)
        
        try await sut.execute(courseId: "c_999")
        
        let args = await repoSpy.getRecordedDeleteArgs()
        #expect(args.count == 1)
        #expect(args.first == "c_999")
    }
    
    @Test("Delete course propagates 404 Not Found error")
    func deleteCoursePropagatesError() async {
        let repoSpy = CourseDetailsRepositorySpy()
        await repoSpy.setDeleteResult(.failure(APIError.serverError(code: 404)))
        let sut = makeDeleteSUT(repo: repoSpy)
        
        await #expect(throws: APIError.serverError(code: 404)) {
            try await sut.execute(courseId: "invalid_course")
        }
    }
}
