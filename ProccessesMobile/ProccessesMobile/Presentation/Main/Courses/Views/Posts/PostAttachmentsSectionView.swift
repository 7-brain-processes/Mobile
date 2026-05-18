//
//  PostAttachmentsSectionView.swift
//  ProccessesMobile
//
//  Created by dark type on 13.03.2026.
//


import SwiftUI

struct PostAttachmentsSectionView: View {
    let title: String
    let attachments: [FeedAttachmentItem]
    let onAttachmentTap: (FeedAttachmentItem) -> Void
    let canDelete: Bool
    let onDelete: (FeedAttachmentItem) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)

            if attachments.isEmpty {
                Text("No attachments")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(attachments) { attachment in
                    AttachmentActionRowView(
                        attachment: attachment,
                        onTap: {
                            onAttachmentTap(attachment)
                        }
                    )
                    .swipeActions {
                        if canDelete {
                            Button(role: .destructive) {
                                onDelete(attachment)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }                }
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
