//
//  SolutionCommentsRepositorySpy.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

actor SolutionCommentsRepositorySpy: SolutionCommentsRepository {
    // Results
    private var listResult: Result<PageComment, Error> = .failure(APIError.invalidResponse)
    private var createResult: Result<Comment, Error> = .failure(APIError.invalidResponse)
    private var updateResult: Result<Comment, Error> = .failure(APIError.invalidResponse)
    private var deleteResult: Result<Void, Error> = .success(())
    
    // Setters
    func setListResult(_ res: Result<PageComment, Error>) { listResult = res }
    func setCreateResult(_ res: Result<Comment, Error>) { createResult = res }
    func setUpdateResult(_ res: Result<Comment, Error>) { updateResult = res }
    func setDeleteResult(_ res: Result<Void, Error>) { deleteResult = res }
    
    // Args Types
    struct ListArgs: Equatable { let cId: String; let pId: String; let sId: String; let page: Int; let size: Int }
    struct CreateArgs: Equatable { let cId: String; let pId: String; let sId: String; let req: CreateCommentRequest }
    struct UpdateArgs: Equatable { let cId: String; let pId: String; let sId: String; let comId: String; let req: CreateCommentRequest }
    struct DeleteArgs: Equatable { let cId: String; let pId: String; let sId: String; let comId: String }
    
    // Trackers
    private var recordedListArgs: [ListArgs] = []
    private var recordedCreateArgs: [CreateArgs] = []
    private var recordedUpdateArgs: [UpdateArgs] = []
    private var recordedDeleteArgs: [DeleteArgs] = []
    
    // Getters
    func getRecordedListArgs() -> [ListArgs] { return recordedListArgs }
    func getRecordedCreateArgs() -> [CreateArgs] { return recordedCreateArgs }
    func getRecordedUpdateArgs() -> [UpdateArgs] { return recordedUpdateArgs }
    func getRecordedDeleteArgs() -> [DeleteArgs] { return recordedDeleteArgs }
    
    // Implementation
    func listComments(courseId: String, postId: String, solutionId: String, page: Int, size: Int) async throws -> PageComment {
        recordedListArgs.append(ListArgs(cId: courseId, pId: postId, sId: solutionId, page: page, size: size))
        return try listResult.get()
    }
    
    func createComment(courseId: String, postId: String, solutionId: String, request: CreateCommentRequest) async throws -> Comment {
        recordedCreateArgs.append(CreateArgs(cId: courseId, pId: postId, sId: solutionId, req: request))
        return try createResult.get()
    }
    
    func updateComment(courseId: String, postId: String, solutionId: String, commentId: String, request: CreateCommentRequest) async throws -> Comment {
        recordedUpdateArgs.append(UpdateArgs(cId: courseId, pId: postId, sId: solutionId, comId: commentId, req: request))
        return try updateResult.get()
    }
    
    func deleteComment(courseId: String, postId: String, solutionId: String, commentId: String) async throws {
        recordedDeleteArgs.append(DeleteArgs(cId: courseId, pId: postId, sId: solutionId, comId: commentId))
        return try deleteResult.get()
    }
}
