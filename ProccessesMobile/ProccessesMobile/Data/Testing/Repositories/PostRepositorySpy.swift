//
//  PostRepositorySpy.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

actor PostRepositorySpy: PostRepository {

    private var listResult: Result<PagePost, Error> = .failure(APIError.invalidResponse)
    private var createResult: Result<Post, Error> = .failure(APIError.invalidResponse)
    private var getResult: Result<Post, Error> = .failure(APIError.invalidResponse)
    private var updateResult: Result<Post, Error> = .failure(APIError.invalidResponse)
    private var deleteResult: Result<Void, Error> = .success(())
    
    func setListResult(_ result: Result<PagePost, Error>) { self.listResult = result }
    func setCreateResult(_ result: Result<Post, Error>) { self.createResult = result }
    func setGetResult(_ result: Result<Post, Error>) { self.getResult = result }
    func setUpdateResult(_ result: Result<Post, Error>) { self.updateResult = result }
    func setDeleteResult(_ result: Result<Void, Error>) { self.deleteResult = result }
    
    struct ListArgs: Equatable { let courseId: String; let page: Int; let size: Int; let type: PostType? }
    struct CreateArgs: Equatable { let courseId: String; let request: CreatePostRequest }
    struct GetArgs: Equatable { let courseId: String; let postId: String }
    struct UpdateArgs: Equatable { let courseId: String; let postId: String; let request: UpdatePostRequest }
    
    private var recordedListArgs: [ListArgs] = []
    private var recordedCreateArgs: [CreateArgs] = []
    private var recordedGetArgs: [GetArgs] = []
    private var recordedUpdateArgs: [UpdateArgs] = []
    private var recordedDeleteArgs: [GetArgs] = []
    
    func getRecordedListArgs() -> [ListArgs] { return recordedListArgs }
    func getRecordedCreateArgs() -> [CreateArgs] { return recordedCreateArgs }
    func getRecordedGetArgs() -> [GetArgs] { return recordedGetArgs }
    func getRecordedUpdateArgs() -> [UpdateArgs] { return recordedUpdateArgs }
    func getRecordedDeleteArgs() -> [GetArgs] { return recordedDeleteArgs }
    
    func listPosts(courseId: String, page: Int, size: Int, type: PostType?) async throws -> PagePost {
        recordedListArgs.append(ListArgs(courseId: courseId, page: page, size: size, type: type))
        return try listResult.get()
    }
    func createPost(courseId: String, request: CreatePostRequest) async throws -> Post {
        recordedCreateArgs.append(CreateArgs(courseId: courseId, request: request))
        return try createResult.get()
    }
    func getPost(courseId: String, postId: String) async throws -> Post {
        recordedGetArgs.append(GetArgs(courseId: courseId, postId: postId))
        return try getResult.get()
    }
    func updatePost(courseId: String, postId: String, request: UpdatePostRequest) async throws -> Post {
        recordedUpdateArgs.append(UpdateArgs(courseId: courseId, postId: postId, request: request))
        return try updateResult.get()
    }
    func deletePost(courseId: String, postId: String) async throws {
        recordedDeleteArgs.append(GetArgs(courseId: courseId, postId: postId))
        return try deleteResult.get()
    }
}
