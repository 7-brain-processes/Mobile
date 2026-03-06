//
//  AttachedFile.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public struct AttachedFile: Equatable, Sendable, Codable {
    public let id: String
    public let originalName: String
    public let contentType: String
    public let sizeBytes: Int64
    public let uploadedAt: String
    
    public init(id: String, originalName: String, contentType: String, sizeBytes: Int64, uploadedAt: String) {
        self.id = id
        self.originalName = originalName
        self.contentType = contentType
        self.sizeBytes = sizeBytes
        self.uploadedAt = uploadedAt
    }
}