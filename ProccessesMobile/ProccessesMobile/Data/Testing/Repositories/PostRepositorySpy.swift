//
//  PostRepositorySpy.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

actor PostRepositorySpy: PostRepository {

    private var listResult: Result<Page<Post>, Error> = .failure(APIError.invalidResponse)
    private var createResult: Result<Post, Error> = .failure(APIError.invalidResponse)
    private var getResult: Result<Post, Error> = .failure(APIError.invalidResponse)
    private var updateResult: Result<Post, Error> = .failure(APIError.invalidResponse)
    private var deleteResult: Result<Void, Error> = .success(())

    private var recordedListQueries: [ListPostsQuery] = []
    private var recordedCreateCommands: [CreatePostCommand] = []
    private var recordedGetArgs: [(courseId: UUID, postId: UUID)] = []
    private var recordedUpdateCommands: [UpdatePostCommand] = []
    private var recordedDeleteArgs: [(courseId: UUID, postId: UUID)] = []

    func setListResult(_ result: Result<Page<Post>, Error>) { self.listResult = result }
    func setCreateResult(_ result: Result<Post, Error>) { self.createResult = result }
    func setGetResult(_ result: Result<Post, Error>) { self.getResult = result }
    func setUpdateResult(_ result: Result<Post, Error>) { self.updateResult = result }
    func setDeleteResult(_ result: Result<Void, Error>) { self.deleteResult = result }

    func getRecordedListQueries() -> [ListPostsQuery] { recordedListQueries }
    func getRecordedCreateCommands() -> [CreatePostCommand] { recordedCreateCommands }
    func getRecordedGetArgs() -> [(courseId: UUID, postId: UUID)] { recordedGetArgs }
    func getRecordedUpdateCommands() -> [UpdatePostCommand] { recordedUpdateCommands }
    func getRecordedDeleteArgs() -> [(courseId: UUID, postId: UUID)] { recordedDeleteArgs }

    func listPosts(_ query: ListPostsQuery) async throws -> Page<Post> {
        recordedListQueries.append(query)
        return try listResult.get()
    }

    func createPost(_ command: CreatePostCommand) async throws -> Post {
        recordedCreateCommands.append(command)
        return try createResult.get()
    }

    func getPost(courseId: UUID, postId: UUID) async throws -> Post {
        recordedGetArgs.append((courseId: courseId, postId: postId))
        return try getResult.get()
    }

    func updatePost(_ command: UpdatePostCommand) async throws -> Post {
        recordedUpdateCommands.append(command)
        return try updateResult.get()
    }

    func deletePost(courseId: UUID, postId: UUID) async throws {
        recordedDeleteArgs.append((courseId: courseId, postId: postId))
        try deleteResult.get()
    }
}
