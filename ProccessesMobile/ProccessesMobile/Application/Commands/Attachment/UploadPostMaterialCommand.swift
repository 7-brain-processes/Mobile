//
//  UploadPostMaterialCommand.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//

import Foundation

struct UploadPostMaterialCommand: Equatable, Sendable {
    let courseId: UUID
    let postId: UUID
    let fileName: String
    let mimeType: String
    let data: Data
}

extension UploadPostMaterialCommand {
    func toDTO() -> UploadFileRequestDTO {
        UploadFileRequestDTO(
            fileName: fileName,
            mimeType: mimeType,
            data: data
        )
    }
}
