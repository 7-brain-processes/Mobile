//
//  LocalAttachmentDraftSource.swift
//  ProccessesMobile
//
//  Created by dark type on 13.03.2026.
//

import Foundation

enum LocalAttachmentDraftSource: Equatable {
    case photo
    case file
}

enum LocalAttachmentDraftStatus: Equatable {
    case pending
    case uploading
    case uploaded(remote: FeedAttachmentItem)
    case failed(message: String)
}

struct LocalAttachmentDraft: Identifiable, Equatable {
    let id: UUID
    let fileName: String
    let localURL: URL
    let source: LocalAttachmentDraftSource
    var status: LocalAttachmentDraftStatus
}

protocol UploadAttachmentUseCase {
    func execute(
        courseId: UUID,
        postId: UUID?,
        fileURL: URL
    ) async throws -> FeedAttachmentItem
}
