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
