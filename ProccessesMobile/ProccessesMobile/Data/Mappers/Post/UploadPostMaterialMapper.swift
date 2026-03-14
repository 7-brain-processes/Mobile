//
//  UploadPostMaterialMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//


enum UploadPostMaterialMapper {
    static func toDTO(_ command: UploadPostMaterialCommand) -> UploadFileRequestDTO {
        UploadFileRequestDTO(
            fileName: command.fileName,
            mimeType: command.mimeType,
            data: command.data
        )
    }
}