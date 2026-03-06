//
//  CourseMembersRepositorySpy.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

actor CourseMembersRepositorySpy: CourseMembersRepository {
    private var removeResult: Result<Void, Error> = .success(())
    func setRemoveResult(_ result: Result<Void, Error>) { removeResult = result }
    
    struct RemoveArgs: Equatable { let courseId: String; let userId: String }
    private var recordedRemoveArgs: [RemoveArgs] = []
    func getRecordedRemoveArgs() -> [RemoveArgs] { return recordedRemoveArgs }
    
    func listMembers(courseId: String, page: Int, size: Int, role: CourseRole?) async throws -> PageMember {
        fatalError("Not implemented in this snippet")
    }
    
    func removeMember(courseId: String, userId: String) async throws {
        recordedRemoveArgs.append(RemoveArgs(courseId: courseId, userId: userId))
        return try removeResult.get()
    }
}
