//
//  PostCommentsRepositorySpy.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

actor PostCommentsRepositorySpy: PostCommentsRepository {

    private var listResult: Result<Page<Comment>, Error> = .failure(APIError.invalidResponse)
    private var createResult: Result<Comment, Error> = .failure(APIError.invalidResponse)
    private var updateResult: Result<Comment, Error> = .failure(APIError.invalidResponse)
    private var deleteResult: Result<Void, Error> = .success(())

    private var recordedListQueries: [ListPostCommentsQuery] = []
    private var recordedCreateCommands: [CreatePostCommentCommand] = []
    private var recordedUpdateCommands: [UpdatePostCommentCommand] = []
    private var recordedDeleteCommands: [DeletePostCommentCommand] = []

    func setListResult(_ result: Result<Page<Comment>, Error>) { listResult = result }
    func setCreateResult(_ result: Result<Comment, Error>) { createResult = result }
    func setUpdateResult(_ result: Result<Comment, Error>) { updateResult = result }
    func setDeleteResult(_ result: Result<Void, Error>) { deleteResult = result }

    func getRecordedListQueries() -> [ListPostCommentsQuery] { recordedListQueries }
    func getRecordedCreateCommands() -> [CreatePostCommentCommand] { recordedCreateCommands }
    func getRecordedUpdateCommands() -> [UpdatePostCommentCommand] { recordedUpdateCommands }
    func getRecordedDeleteCommands() -> [DeletePostCommentCommand] { recordedDeleteCommands }

    func listComments(_ query: ListPostCommentsQuery) async throws -> Page<Comment> {
        recordedListQueries.append(query)
        return try listResult.get()
    }

    func createComment(_ command: CreatePostCommentCommand) async throws -> Comment {
        recordedCreateCommands.append(command)
        return try createResult.get()
    }

    func updateComment(_ command: UpdatePostCommentCommand) async throws -> Comment {
        recordedUpdateCommands.append(command)
        return try updateResult.get()
    }

    func deleteComment(_ command: DeletePostCommentCommand) async throws {
        recordedDeleteCommands.append(command)
        try deleteResult.get()
    }
}
