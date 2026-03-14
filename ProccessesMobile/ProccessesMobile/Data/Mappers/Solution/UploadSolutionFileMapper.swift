//
//  UploadSolutionFileMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//


enum UploadSolutionFileMapper {
    static func toDTO(_ command: UploadSolutionFileCommand) -> UploadFileRequestDTO {
        UploadFileRequestDTO(
            fileName: command.fileName,
            mimeType: command.mimeType,
            data: command.data
        )
    }
}
