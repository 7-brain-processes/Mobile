//
//  AttachedFile.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct AttachedFile: Equatable, Sendable, Codable {
    let id: UUID
    let originalName: String
    let contentType: String
    let sizeBytes: Int64
    let uploadedAt: String
    
    init(id: UUID, originalName: String, contentType: String, sizeBytes: Int64, uploadedAt: String) {
        self.id = id
        self.originalName = originalName
        self.contentType = contentType
        self.sizeBytes = sizeBytes
        self.uploadedAt = uploadedAt
    }
}
