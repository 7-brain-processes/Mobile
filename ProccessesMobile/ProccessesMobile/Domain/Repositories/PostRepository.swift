//
//  PostRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


protocol PostRepository: Sendable {
    func listPosts(courseId: String, page: Int, size: Int, type: PostType?) async throws -> PagePost
    func createPost(courseId: String, request: CreatePostRequest) async throws -> Post
    func getPost(courseId: String, postId: String) async throws -> Post
    func updatePost(courseId: String, postId: String, request: UpdatePostRequest) async throws -> Post
    func deletePost(courseId: String, postId: String) async throws
}
