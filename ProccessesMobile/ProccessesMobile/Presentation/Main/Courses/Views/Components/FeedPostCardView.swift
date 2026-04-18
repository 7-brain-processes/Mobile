//
//  FeedPostCardView.swift
//  ProccessesMobile
//
//  Created by dark type on 12.03.2026.
//


import SwiftUI

struct FeedPostCardView: View {
    let post: FeedPostItem
    let onTap: () -> Void
    let onCommentTap: () -> Void
    let onAttachmentTap: (FeedAttachmentItem) -> Void

    private var formattedDate: String {
        post.createdAt.formatted(date: .abbreviated, time: .omitted)
    }

    private var deadlineText: String? {
        guard let deadline = post.deadline else { return nil }
        return deadline.formatted(date: .abbreviated, time: .shortened)
    }

    private var chipColor: Color {
        post.type == .task ? .orange : .blue
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Button(action: onTap) {
                VStack(alignment: .leading, spacing: 14) {
                    HStack(alignment: .top, spacing: 12) {
                        InitialAvatarView(
                            name: post.author.displayName,
                            size: 40,
                            backgroundColor: chipColor
                        )

                        VStack(alignment: .leading, spacing: 6) {
                            Text(post.author.displayName)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.primary)

                            HStack(spacing: 8) {
                                Text(post.type.title)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(chipColor.opacity(0.14))
                                    .foregroundStyle(chipColor)
                                    .clipShape(Capsule())

                                Text(formattedDate)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Spacer()
                    }

                    Text(post.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)

                    if !post.contentPreview.isEmpty {
                        Text(post.contentPreview)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                    }

                    if let deadlineText {
                        Label("Due \(deadlineText)", systemImage: "calendar")
                            .font(.caption)
                            .foregroundStyle(.orange)
                    }

                    if !post.attachments.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(post.attachments) { attachment in
                                    Button {
                                        onAttachmentTap(attachment)
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 14)
                                                .fill(Color(.secondarySystemBackground))
                                                .frame(width: 120, height: 88)

                                            VStack(spacing: 8) {
                                                Image(systemName: "photo")
                                                    .font(.title3)
                                                    .foregroundStyle(.secondary)

                                                Text(attachment.fileName)
                                                    .font(.caption2)
                                                    .foregroundStyle(.secondary)
                                                    .lineLimit(1)
                                            }
                                            .padding(8)
                                        }
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)

            Divider()

            HStack {
                Button(action: onCommentTap) {
                    Text("\(post.commentsCount) comments")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)

                Spacer()
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.black.opacity(0.04), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}
