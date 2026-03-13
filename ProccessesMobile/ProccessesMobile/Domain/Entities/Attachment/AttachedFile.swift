//
//  AttachedFile.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct AttachedFile: Equatable, Sendable {
    let id: UUID
    let originalName: String
    let contentType: String
    let sizeBytes: Int64
    let uploadedAt: Date
}
extension AttachedFile {
    func toFeedAttachmentItem() -> FeedAttachmentItem {
        FeedAttachmentItem(
            id: id,
            type: FeedAttachmentType.from(mimeType: contentType),
            fileName: originalName,
            previewURL: nil
        )
    }
}

extension FeedAttachmentType {
    static func from(mimeType: String) -> FeedAttachmentType {
        if mimeType.hasPrefix("image/") {
            return .image
        } else if mimeType.hasPrefix("audio/") {
            return .audio
        } else {
            return .file
        }
    }
}
