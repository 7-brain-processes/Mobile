//
//  CourseMembersRepositorySpy.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

actor CourseMembersRepositorySpy: CourseMembersRepository {

    // MARK: Results

    private var listResult: Result<Page<Member>, Error> =
        .failure(APIError.invalidResponse)

    private var removeResult: Result<Void, Error> =
        .success(())


    // MARK: Recorded calls

    private var recordedListQueries: [ListMembersQuery] = []
    private var recordedRemoveCommands: [RemoveMemberCommand] = []


    // MARK: Configure results

    func setListResult(_ result: Result<Page<Member>, Error>) {
        listResult = result
    }

    func setRemoveResult(_ result: Result<Void, Error>) {
        removeResult = result
    }


    // MARK: Inspect

    func getRecordedListQueries() -> [ListMembersQuery] {
        recordedListQueries
    }

    func getRecordedRemoveCommands() -> [RemoveMemberCommand] {
        recordedRemoveCommands
    }


    // MARK: Repository methods

    func listMembers(_ query: ListMembersQuery) async throws -> Page<Member> {
        recordedListQueries.append(query)
        return try listResult.get()
    }

    func removeMember(_ command: RemoveMemberCommand) async throws {
        recordedRemoveCommands.append(command)
        try removeResult.get()
    }
}
