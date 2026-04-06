//
//  SolutionCommentsRepositorySpy.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

actor SolutionCommentsRepositorySpy: SolutionCommentsRepository {

    private var listResult: Result<Page<Comment>, Error> = .failure(APIError.invalidResponse)
    private var createResult: Result<Comment, Error> = .failure(APIError.invalidResponse)
    private var updateResult: Result<Comment, Error> = .failure(APIError.invalidResponse)
    private var deleteResult: Result<Void, Error> = .success(())

    func setListResult(_ res: Result<Page<Comment>, Error>) { listResult = res }
    func setCreateResult(_ res: Result<Comment, Error>) { createResult = res }
    func setUpdateResult(_ res: Result<Comment, Error>) { updateResult = res }
    func setDeleteResult(_ res: Result<Void, Error>) { deleteResult = res }

    private var recordedListQueries: [ListSolutionCommentsQuery] = []
    private var recordedCreateCommands: [CreateSolutionCommentCommand] = []
    private var recordedUpdateCommands: [UpdateSolutionCommentCommand] = []
    private var recordedDeleteCommands: [DeleteSolutionCommentCommand] = []

    func getRecordedListQueries() -> [ListSolutionCommentsQuery] { recordedListQueries }
    func getRecordedCreateCommands() -> [CreateSolutionCommentCommand] { recordedCreateCommands }
    func getRecordedUpdateCommands() -> [UpdateSolutionCommentCommand] { recordedUpdateCommands }
    func getRecordedDeleteCommands() -> [DeleteSolutionCommentCommand] { recordedDeleteCommands }

    func listComments(_ query: ListSolutionCommentsQuery) async throws -> Page<Comment> {
        recordedListQueries.append(query)
        return try listResult.get()
    }

    func createComment(_ command: CreateSolutionCommentCommand) async throws -> Comment {
        recordedCreateCommands.append(command)
        return try createResult.get()
    }

    func updateComment(_ command: UpdateSolutionCommentCommand) async throws -> Comment {
        recordedUpdateCommands.append(command)
        return try updateResult.get()
    }

    func deleteComment(_ command: DeleteSolutionCommentCommand) async throws {
        recordedDeleteCommands.append(command)
        try deleteResult.get()
    }
}
