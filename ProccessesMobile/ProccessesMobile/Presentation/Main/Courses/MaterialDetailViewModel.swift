//
//  MaterialDetailViewModel.swift
//  ProccessesMobile
//
//  Created by dark type on 12.03.2026.
//


import Combine
import Foundation

@MainActor
final class MaterialDetailViewModel: ObservableObject {
    @Published var item: MaterialDetailItem
    @Published var draftComment: String = ""
    @Published var previewAttachment: FeedAttachmentItem?

    init(item: MaterialDetailItem) {
        self.item = item
    }

    func addComment(as authorName: String = "You") {
        let trimmed = draftComment.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let newComment = PostCommentItem(
            id: UUID(),
            authorName: authorName,
            text: trimmed,
            createdAt: Date()
        )

        item = MaterialDetailItem(
            id: item.id,
            title: item.title,
            content: item.content,
            createdAt: item.createdAt,
            authorDisplayName: item.authorDisplayName,
            attachments: item.attachments,
            comments: item.comments + [newComment]
        )

        draftComment = ""
    }

    func openAttachment(_ attachment: FeedAttachmentItem) {
        previewAttachment = attachment
    }

    func downloadAttachment(_ attachment: FeedAttachmentItem) {
        print("Download attachment: \(attachment.fileName)")
    }

    func shareAttachment(_ attachment: FeedAttachmentItem) {
        print("Share attachment: \(attachment.fileName)")
    }
}
