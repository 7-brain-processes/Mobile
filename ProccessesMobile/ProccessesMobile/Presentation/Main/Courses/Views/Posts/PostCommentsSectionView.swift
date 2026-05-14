//
//  PostCommentsSectionView.swift
//  ProccessesMobile
//
//  Created by dark type on 12.03.2026.
//

import SwiftUI

struct PostCommentsSectionView: View {
    let comments: [PostCommentItem]
    @Binding var draftComment: String
    let onSendComment: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Comments")
                .font(.headline)

            PostCommentComposerView(
                text: $draftComment,
                placeholder: "Add class comment",
                onSend: onSendComment
            )

            if comments.isEmpty {
                Text("No comments yet")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(comments) { comment in
                    HStack(alignment: .top, spacing: 12) {
                        InitialAvatarView(
                            name: comment.authorName,
                            size: 32,
                            backgroundColor: .gray
                        )

                        VStack(alignment: .leading, spacing: 4) {
                            Text(comment.authorName)
                                .font(.subheadline)
                                .fontWeight(.semibold)

                            Text(comment.createdAt.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            Text(comment.text)
                                .font(.body)
                                .foregroundStyle(.primary)
                        }

                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
