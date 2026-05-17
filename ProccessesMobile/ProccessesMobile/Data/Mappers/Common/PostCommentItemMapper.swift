//
//  PostCommentItemMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 14.05.2026.
//


enum PostCommentItemMapper {
    static func toItem(_ comment: Comment) -> PostCommentItem {
        PostCommentItem(
            id: comment.id,
            authorName: comment.author?.displayName ?? "Unknown",
            text: comment.text,
            createdAt: comment.createdAt
        )
    }
}