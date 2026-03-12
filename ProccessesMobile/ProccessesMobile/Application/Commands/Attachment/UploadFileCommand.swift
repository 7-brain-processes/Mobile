//
//  UploadFileCommand.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct UploadSolutionFileCommand: Equatable, Sendable {
    let courseId: UUID
    let postId: UUID
    let solutionId: UUID
    let fileName: String
    let mimeType: String
    let data: Data
}
