//
//  CourseInvitesRepositorySpy.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

actor CourseInvitesRepositorySpy: CourseInvitesRepository {

    // MARK: Results

    private var createResult: Result<Invite, Error> =
        .failure(APIError.invalidResponse)

    private var revokeResult: Result<Void, Error> =
        .success(())

    private var listResult: Result<[Invite], Error> =
        .failure(APIError.invalidResponse)


    // MARK: Configure results

    func setCreateResult(_ result: Result<Invite, Error>) {
        createResult = result
    }

    func setRevokeResult(_ result: Result<Void, Error>) {
        revokeResult = result
    }

    func setListResult(_ result: Result<[Invite], Error>) {
        listResult = result
    }


    // MARK: Recorded calls

    private var recordedCreateCommands: [CreateInviteCommand] = []
    private var recordedRevokeCommands: [RevokeInviteCommand] = []
    private var recordedListCourseIds: [UUID] = []


    // MARK: Inspect

    func getRecordedCreateCommands() -> [CreateInviteCommand] {
        recordedCreateCommands
    }

    func getRecordedRevokeCommands() -> [RevokeInviteCommand] {
        recordedRevokeCommands
    }

    func getRecordedListCourseIds() -> [UUID] {
        recordedListCourseIds
    }


    // MARK: Repository methods

    func listInvites(courseId: UUID) async throws -> [Invite] {
        recordedListCourseIds.append(courseId)
        return try listResult.get()
    }

    func createInvite(_ command: CreateInviteCommand) async throws -> Invite {
        recordedCreateCommands.append(command)
        return try createResult.get()
    }

    func revokeInvite(_ command: RevokeInviteCommand) async throws {
        recordedRevokeCommands.append(command)
        try revokeResult.get()
    }
}
