//
//  AttachedFile.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

struct AttachedFileDTO: Equatable, Sendable, Codable {
    let id: String
    let originalName: String
    let contentType: String
    let sizeBytes: Int64
    let uploadedAt: String
    
    init(id: String, originalName: String, contentType: String, sizeBytes: Int64, uploadedAt: String) {
        self.id = id
        self.originalName = originalName
        self.contentType = contentType
        self.sizeBytes = sizeBytes
        self.uploadedAt = uploadedAt
    }
}
