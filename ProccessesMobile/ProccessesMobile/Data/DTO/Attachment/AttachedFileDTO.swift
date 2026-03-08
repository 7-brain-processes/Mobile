//
//  AttachedFile.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

import Foundation

struct AttachedFileDTO: Equatable, Sendable, Codable {
    let id: String
    let originalName: String
    let contentType: String
    let sizeBytes: Int64
    let uploadedAt: String
}

extension AttachedFileDTO {
    func toDomain() throws -> AttachedFile {
        AttachedFile(
            id: try parseUUID(id),
            originalName: originalName,
            contentType: contentType,
            sizeBytes: sizeBytes,
            uploadedAt: try parseDate(uploadedAt)
        )
    }
}
