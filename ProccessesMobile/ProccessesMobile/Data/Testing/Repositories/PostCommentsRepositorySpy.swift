//
//  PostCommentsRepositorySpy.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


actor PostCommentsRepositorySpy: PostCommentsRepository {
    private var createResult: Result<Comment, Error> = .failure(APIError.invalidResponse)
    func setCreateResult(_ result: Result<Comment, Error>) { createResult = result }
    
    struct CreateArgs: Equatable { let courseId: String; let postId: String; let request: CreateCommentRequest }
    private var recordedCreateArgs: [CreateArgs] = []
    func getRecordedCreateArgs() -> [CreateArgs] { return recordedCreateArgs }
    
    func listComments(courseId: String, postId: String, page: Int, size: Int) async throws -> PageComment { fatalError() }
    
    func createComment(courseId: String, postId: String, request: CreateCommentRequest) async throws -> Comment {
        recordedCreateArgs.append(CreateArgs(courseId: courseId, postId: postId, request: request))
        return try createResult.get()
    }
    
    func updateComment(courseId: String, postId: String, commentId: String, request: CreateCommentRequest) async throws -> Comment { fatalError() }
    func deleteComment(courseId: String, postId: String, commentId: String) async throws { fatalError() }
}