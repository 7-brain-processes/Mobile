//
//  AttachedFileMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//

import Foundation

enum AttachedFileMapper {
    static func toDomain(_ dto: AttachedFileDTO) throws -> AttachedFile {
        AttachedFile(
            id: try parseUUID(dto.id),
            originalName: dto.originalName,
            contentType: dto.contentType,
            sizeBytes: dto.sizeBytes,
            uploadedAt: try parseDate(dto.uploadedAt)
        )
    }
}
