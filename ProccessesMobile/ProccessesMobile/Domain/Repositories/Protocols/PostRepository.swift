//
//  PostRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

protocol PostRepository: Sendable {
    func listPosts(_ query: ListPostsQuery) async throws -> Page<Post>
    func createPost(_ command: CreatePostCommand) async throws -> Post
    func getPost(courseId: UUID, postId: UUID) async throws -> Post
    func updatePost(_ command: UpdatePostCommand) async throws -> Post
    func deletePost(courseId: UUID, postId: UUID) async throws
}
