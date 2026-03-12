//
//  AttachedFileMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//

import Foundation

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
