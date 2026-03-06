//
//  CourseInvitesRepositorySpy.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

actor CourseInvitesRepositorySpy: CourseInvitesRepository {
    private var createResult: Result<Invite, Error> = .failure(APIError.invalidResponse)
    private var revokeResult: Result<Void, Error> = .success(())
    
    func setCreateResult(_ result: Result<Invite, Error>) { createResult = result }
    func setRevokeResult(_ result: Result<Void, Error>) { revokeResult = result }
    
    struct CreateArgs: Equatable { let courseId: String; let request: CreateInviteRequest }
    struct RevokeArgs: Equatable { let courseId: String; let inviteId: String }
    
    private var recordedCreateArgs: [CreateArgs] = []
    private var recordedRevokeArgs: [RevokeArgs] = []
    
    func getRecordedCreateArgs() -> [CreateArgs] { return recordedCreateArgs }
    func getRecordedRevokeArgs() -> [RevokeArgs] { return recordedRevokeArgs }
    
    func listInvites(courseId: String) async throws -> [Invite] { fatalError() }
    
    func createInvite(courseId: String, request: CreateInviteRequest) async throws -> Invite {
        recordedCreateArgs.append(CreateArgs(courseId: courseId, request: request))
        return try createResult.get()
    }
    
    func revokeInvite(courseId: String, inviteId: String) async throws {
        recordedRevokeArgs.append(RevokeArgs(courseId: courseId, inviteId: inviteId))
        return try revokeResult.get()
    }
}
